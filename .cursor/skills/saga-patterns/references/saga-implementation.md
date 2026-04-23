# Saga Implementation Guide for Java/Spring Boot

## Choreography Pattern

Each service publishes domain events; downstream services react independently.

### Spring Application Events (In-Process)
```java
public sealed interface OrderEvent permits OrderCreated, OrderCancelled {}
public record OrderCreated(UUID orderId, UUID customerId, BigDecimal total) implements OrderEvent {}
public record OrderCancelled(UUID orderId, String reason) implements OrderEvent {}

@Service
public class OrderService {
    private final ApplicationEventPublisher eventPublisher;
    private final OrderRepository orderRepository;

    public OrderService(ApplicationEventPublisher eventPublisher, OrderRepository orderRepository) {
        this.eventPublisher = eventPublisher;
        this.orderRepository = orderRepository;
    }

    @Transactional
    public Order createOrder(CreateOrderCommand command) {
        var order = Order.create(command);
        orderRepository.save(order);
        eventPublisher.publishEvent(new OrderCreated(order.id(), command.customerId(), order.total()));
        return order;
    }
}

@Service
public class InventoryListener {
    private final InventoryService inventoryService;

    public InventoryListener(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onOrderCreated(OrderCreated event) {
        try {
            inventoryService.reserveStock(event.orderId(), event.customerId());
        } catch (InsufficientStockException e) {
            inventoryService.publishCompensation(event.orderId(), e.getMessage());
        }
    }
}
```

### Kafka-Based Choreography (Cross-Service)
```java
@Service
public class OrderEventPublisher {
    private final KafkaTemplate<String, OrderEvent> kafkaTemplate;

    public OrderEventPublisher(KafkaTemplate<String, OrderEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void publish(OrderCreated event) {
        kafkaTemplate.send("order-events", event.orderId().toString(), event);
    }
}

@Component
public class PaymentSagaListener {
    private final PaymentService paymentService;
    private final KafkaTemplate<String, PaymentEvent> kafkaTemplate;

    @KafkaListener(topics = "order-events", groupId = "payment-service")
    public void handle(OrderCreated event) {
        try {
            paymentService.processPayment(event.orderId(), event.total());
            kafkaTemplate.send("payment-events", event.orderId().toString(),
                new PaymentCompleted(event.orderId()));
        } catch (PaymentFailedException e) {
            kafkaTemplate.send("payment-events", event.orderId().toString(),
                new PaymentFailed(event.orderId(), e.getMessage()));
        }
    }
}
```

## Orchestration Pattern

A central coordinator drives the saga steps using a state machine.

### Spring State Machine Orchestrator
```java
public enum SagaState {
    ORDER_CREATED,
    INVENTORY_RESERVED,
    PAYMENT_PROCESSED,
    SHIPPING_SCHEDULED,
    COMPLETED,
    COMPENSATING,
    FAILED
}

public enum SagaEvent {
    RESERVE_INVENTORY,
    INVENTORY_RESERVED,
    INVENTORY_FAILED,
    PROCESS_PAYMENT,
    PAYMENT_COMPLETED,
    PAYMENT_FAILED,
    SCHEDULE_SHIPPING,
    SHIPPING_SCHEDULED,
    SHIPPING_FAILED
}

@Configuration
@EnableStateMachine
public class OrderSagaConfig extends StateMachineConfigurerAdapter<SagaState, SagaEvent> {

    @Override
    public void configure(StateMachineStateConfigurer<SagaState, SagaEvent> states) throws Exception {
        states
            .withStates()
            .initial(SagaState.ORDER_CREATED)
            .end(SagaState.COMPLETED)
            .end(SagaState.FAILED)
            .states(EnumSet.allOf(SagaState.class));
    }

    @Override
    public void configure(StateMachineTransitionConfigurer<SagaState, SagaEvent> transitions) throws Exception {
        transitions
            .withExternal().source(SagaState.ORDER_CREATED).target(SagaState.INVENTORY_RESERVED)
                .event(SagaEvent.INVENTORY_RESERVED)
            .and()
            .withExternal().source(SagaState.ORDER_CREATED).target(SagaState.COMPENSATING)
                .event(SagaEvent.INVENTORY_FAILED)
            .and()
            .withExternal().source(SagaState.INVENTORY_RESERVED).target(SagaState.PAYMENT_PROCESSED)
                .event(SagaEvent.PAYMENT_COMPLETED)
            .and()
            .withExternal().source(SagaState.INVENTORY_RESERVED).target(SagaState.COMPENSATING)
                .event(SagaEvent.PAYMENT_FAILED)
            .and()
            .withExternal().source(SagaState.PAYMENT_PROCESSED).target(SagaState.COMPLETED)
                .event(SagaEvent.SHIPPING_SCHEDULED);
    }
}
```

### Saga Orchestrator Service
```java
@Service
public class OrderSagaOrchestrator {
    private final InventoryService inventoryService;
    private final PaymentService paymentService;
    private final ShippingService shippingService;
    private final SagaStateRepository sagaStateRepository;

    @Transactional
    public void executeSaga(UUID orderId) {
        var saga = sagaStateRepository.findByOrderId(orderId)
            .orElseThrow(() -> new SagaNotFoundException(orderId));

        try {
            executeStep(saga, SagaState.INVENTORY_RESERVED,
                () -> inventoryService.reserveStock(orderId),
                () -> inventoryService.releaseStock(orderId));

            executeStep(saga, SagaState.PAYMENT_PROCESSED,
                () -> paymentService.charge(orderId),
                () -> paymentService.refund(orderId));

            executeStep(saga, SagaState.COMPLETED,
                () -> shippingService.schedule(orderId),
                () -> shippingService.cancel(orderId));

        } catch (SagaStepFailedException e) {
            compensate(saga, e);
        }
    }

    private void executeStep(SagaInstance saga, SagaState targetState,
                             Runnable action, Runnable compensation) {
        saga.registerCompensation(targetState, compensation);
        action.run();
        saga.transitionTo(targetState);
        sagaStateRepository.save(saga);
    }

    private void compensate(SagaInstance saga, SagaStepFailedException cause) {
        saga.compensationsInReverseOrder().forEach(compensation -> {
            try {
                compensation.run();
            } catch (Exception e) {
                log.error("Compensation failed for saga {}: {}", saga.id(), e.getMessage());
            }
        });
        saga.transitionTo(SagaState.FAILED);
        sagaStateRepository.save(saga);
    }
}
```

## Idempotency

Every saga step must be safe to retry. Use idempotency keys:

```java
@Service
public class IdempotentPaymentService {
    private final IdempotencyKeyRepository idempotencyRepository;
    private final PaymentGateway paymentGateway;

    @Transactional
    public PaymentResult processPayment(UUID idempotencyKey, PaymentRequest request) {
        var existing = idempotencyRepository.findByKey(idempotencyKey);
        if (existing.isPresent()) {
            return existing.get().result();
        }

        var result = paymentGateway.charge(request);
        idempotencyRepository.save(new IdempotencyRecord(idempotencyKey, result));
        return result;
    }
}
```

## Compensation Checklist

| Step | Forward Action | Compensation |
|------|---------------|--------------|
| Inventory | Reserve stock | Release reserved stock |
| Payment | Charge customer | Refund payment |
| Shipping | Schedule shipment | Cancel shipment |
| Notification | Send confirmation | Send cancellation notice |

## Failure Handling

| Failure Mode | Strategy |
|-------------|----------|
| Transient failure (timeout, network) | Retry with exponential backoff |
| Business failure (insufficient stock) | Compensate immediately |
| Compensation failure | Log, alert, manual intervention queue |
| Poison message | Dead letter queue + alerting |
| Saga timeout | Timeout compensator triggers after SLA |

## Testing Sagas

```java
@Test
void shouldCompensateWhenPaymentFails() {
    given(inventoryService.reserveStock(any())).willReturn(success());
    given(paymentService.charge(any())).willThrow(new PaymentFailedException("Insufficient funds"));

    orchestrator.executeSaga(orderId);

    verify(inventoryService).releaseStock(orderId);
    assertThat(sagaRepository.findByOrderId(orderId).get().state()).isEqualTo(SagaState.FAILED);
}

@Test
void shouldBeIdempotentOnRetry() {
    orchestrator.executeSaga(orderId);
    orchestrator.executeSaga(orderId);

    verify(paymentService, times(1)).charge(orderId);
}
```
