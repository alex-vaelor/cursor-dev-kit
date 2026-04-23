# Resilience Patterns for Java/Spring Boot

## Overview

Resilience patterns prevent cascading failures in distributed systems. In Spring Boot, use Resilience4j as the primary library.

## Circuit Breaker

Prevents calls to a failing service, allowing it time to recover.

```java
@Service
public class PaymentService {
    private final PaymentGatewayClient client;

    @CircuitBreaker(name = "paymentGateway", fallbackMethod = "paymentFallback")
    public PaymentResult processPayment(PaymentRequest request) {
        return client.charge(request);
    }

    private PaymentResult paymentFallback(PaymentRequest request, Exception ex) {
        log.warn("Payment gateway unavailable, queuing for retry: {}", ex.getMessage());
        return PaymentResult.queued(request.orderId());
    }
}
```

Configuration:
```yaml
resilience4j:
  circuitbreaker:
    instances:
      paymentGateway:
        sliding-window-type: COUNT_BASED
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 30s
        permitted-number-of-calls-in-half-open-state: 3
        slow-call-rate-threshold: 80
        slow-call-duration-threshold: 2s
```

### Circuit Breaker States

| State | Behavior |
|-------|----------|
| CLOSED | Normal operation; failures counted |
| OPEN | All calls rejected; fallback invoked |
| HALF_OPEN | Limited calls allowed to test recovery |

## Retry with Exponential Backoff

Automatically retry transient failures with increasing delays.

```java
@Service
public class NotificationService {
    private final EmailClient emailClient;

    @Retry(name = "emailService", fallbackMethod = "emailFallback")
    public void sendNotification(Notification notification) {
        emailClient.send(notification.toEmail());
    }

    private void sendNotification(Notification notification, Exception ex) {
        log.error("Email delivery failed after retries: {}", ex.getMessage());
        deadLetterQueue.enqueue(notification);
    }
}
```

Configuration:
```yaml
resilience4j:
  retry:
    instances:
      emailService:
        max-attempts: 3
        wait-duration: 1s
        exponential-backoff-multiplier: 2
        retry-exceptions:
          - java.net.ConnectException
          - java.net.SocketTimeoutException
          - org.springframework.web.client.ResourceAccessException
        ignore-exceptions:
          - com.example.BusinessValidationException
```

**Retry only idempotent operations.** Non-idempotent operations (payment charges, order creation) need idempotency keys.

## Bulkhead

Isolate failures to prevent one slow dependency from consuming all threads.

```java
@Service
public class CatalogService {

    @Bulkhead(name = "catalogSearch", type = Bulkhead.Type.SEMAPHORE)
    public List<Product> search(String query) {
        return catalogClient.search(query);
    }
}
```

Configuration:
```yaml
resilience4j:
  bulkhead:
    instances:
      catalogSearch:
        max-concurrent-calls: 10
        max-wait-duration: 500ms
```

## Rate Limiter

Protect services from being overwhelmed by too many requests.

```java
@RestController
public class PublicApiController {

    @RateLimiter(name = "publicApi")
    @GetMapping("/api/public/search")
    public ResponseEntity<SearchResults> search(@RequestParam String query) {
        return ResponseEntity.ok(searchService.search(query));
    }
}
```

Configuration:
```yaml
resilience4j:
  ratelimiter:
    instances:
      publicApi:
        limit-for-period: 100
        limit-refresh-period: 1s
        timeout-duration: 0s
```

## Timeout

Prevent indefinite waits for slow dependencies.

```java
@Service
public class InventoryService {

    @TimeLimiter(name = "inventoryCheck")
    public CompletableFuture<StockLevel> checkStock(String productId) {
        return CompletableFuture.supplyAsync(() -> inventoryClient.getStock(productId));
    }
}
```

Configuration:
```yaml
resilience4j:
  timelimiter:
    instances:
      inventoryCheck:
        timeout-duration: 3s
        cancel-running-future: true
```

## Combining Patterns

Order matters. Resilience4j applies decorators in this order:
`Retry → CircuitBreaker → RateLimiter → TimeLimiter → Bulkhead`

```java
@CircuitBreaker(name = "externalApi")
@Retry(name = "externalApi")
@Bulkhead(name = "externalApi")
public ExternalData callExternalApi(String id) {
    return externalClient.getData(id);
}
```

## Graceful Degradation

When a dependency is unavailable, degrade gracefully instead of failing:

```java
public record ProductDetails(
    Product product,
    List<Review> reviews,
    List<Recommendation> recommendations
) {
    public static ProductDetails degraded(Product product) {
        return new ProductDetails(product, List.of(), List.of());
    }
}

@Service
public class ProductPageService {
    @CircuitBreaker(name = "reviewService", fallbackMethod = "degradedReviews")
    public List<Review> getReviews(String productId) {
        return reviewClient.getReviews(productId);
    }

    private List<Review> degradedReviews(String productId, Exception ex) {
        return List.of(); // empty reviews rather than page error
    }
}
```

## Error Aggregation Pattern

Collect multiple errors instead of failing on the first:

```java
public sealed interface ValidationResult {
    record Success() implements ValidationResult {}
    record Failure(List<String> errors) implements ValidationResult {}
}

public ValidationResult validateOrder(OrderRequest request) {
    var errors = new ArrayList<String>();

    if (request.items().isEmpty()) errors.add("Order must have at least one item");
    if (request.total().compareTo(BigDecimal.ZERO) <= 0) errors.add("Total must be positive");
    if (request.shippingAddress() == null) errors.add("Shipping address required");

    return errors.isEmpty()
        ? new ValidationResult.Success()
        : new ValidationResult.Failure(List.copyOf(errors));
}
```

## Testing Resilience

```java
@SpringBootTest
class PaymentServiceResilienceTest {
    @MockBean
    private PaymentGatewayClient gatewayClient;

    @Autowired
    private PaymentService paymentService;

    @Test
    void circuitBreakerShouldOpenAfterFailures() {
        given(gatewayClient.charge(any())).willThrow(new ConnectException("Connection refused"));

        IntStream.range(0, 10).forEach(i -> {
            assertThatThrownBy(() -> paymentService.processPayment(request))
                .isInstanceOf(ConnectException.class);
        });

        var cbRegistry = CircuitBreakerRegistry.ofDefaults();
        var cb = cbRegistry.circuitBreaker("paymentGateway");
        assertThat(cb.getState()).isEqualTo(CircuitBreaker.State.OPEN);
    }

    @Test
    void shouldRetryOnTransientFailure() {
        given(gatewayClient.charge(any()))
            .willThrow(new SocketTimeoutException("Timeout"))
            .willThrow(new SocketTimeoutException("Timeout"))
            .willReturn(PaymentResult.success());

        var result = paymentService.processPayment(request);
        assertThat(result.isSuccess()).isTrue();
        verify(gatewayClient, times(3)).charge(any());
    }
}
```

## Pattern Selection Guide

| Scenario | Pattern | Configuration Guidance |
|----------|---------|----------------------|
| External service intermittently down | Circuit Breaker | Threshold: 50% failure in 10-call window |
| Network timeouts | Retry + Timeout | 3 retries, exponential backoff, 3s timeout |
| Slow dependency consuming threads | Bulkhead | Max concurrent: 10-20% of thread pool |
| Public API abuse | Rate Limiter | Based on SLA (e.g., 100 req/s) |
| Non-critical enrichment call | Circuit Breaker + Fallback | Return empty/default on failure |
| Payment processing | Retry + Idempotency Key | Max 3 retries with idempotency key |
