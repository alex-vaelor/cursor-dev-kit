# Micrometer Patterns for Spring Boot

## Meter Types

| Type | Purpose | Example |
|------|---------|---------|
| **Counter** | Count events (monotonically increasing) | Orders created, errors occurred |
| **Timer** | Measure duration + count | API response time, DB query time |
| **Gauge** | Current value (can go up/down) | Queue depth, active connections |
| **DistributionSummary** | Measure size distributions | Request payload size, batch sizes |
| **LongTaskTimer** | Track long-running tasks in progress | Background job duration |

## Counter Pattern
```java
@Service
public class OrderService {
    private final Counter successCounter;
    private final Counter failureCounter;

    public OrderService(MeterRegistry registry) {
        this.successCounter = Counter.builder("orders.created")
            .tag("outcome", "success")
            .description("Successfully created orders")
            .register(registry);
        this.failureCounter = Counter.builder("orders.created")
            .tag("outcome", "failure")
            .description("Failed order creations")
            .register(registry);
    }

    public Order createOrder(OrderRequest request) {
        try {
            var order = processOrder(request);
            successCounter.increment();
            return order;
        } catch (Exception e) {
            failureCounter.increment();
            throw e;
        }
    }
}
```

## Timer Pattern
```java
@Service
public class PaymentService {
    private final Timer paymentTimer;

    public PaymentService(MeterRegistry registry) {
        this.paymentTimer = Timer.builder("payment.processing")
            .description("Payment processing duration")
            .publishPercentiles(0.5, 0.95, 0.99)
            .publishPercentileHistogram()
            .sla(Duration.ofMillis(200), Duration.ofMillis(500), Duration.ofSeconds(1))
            .register(registry);
    }

    public PaymentResult process(PaymentRequest request) {
        return paymentTimer.record(() -> gateway.charge(request));
    }
}
```

## Gauge Pattern
```java
@Component
public class QueueMetrics implements MeterBinder {
    private final TaskQueue taskQueue;

    public QueueMetrics(TaskQueue taskQueue) {
        this.taskQueue = taskQueue;
    }

    @Override
    public void bindTo(MeterRegistry registry) {
        Gauge.builder("task.queue.size", taskQueue, TaskQueue::size)
            .description("Current number of tasks in queue")
            .register(registry);
        Gauge.builder("task.queue.oldest.age.seconds", taskQueue, q ->
            q.oldestTaskAge().map(Duration::toSeconds).orElse(0L))
            .description("Age of the oldest task in seconds")
            .register(registry);
    }
}
```

## Distribution Summary
```java
@Component
public class RequestSizeMetrics {
    private final DistributionSummary requestSize;

    public RequestSizeMetrics(MeterRegistry registry) {
        this.requestSize = DistributionSummary.builder("http.request.size")
            .description("Request body size in bytes")
            .baseUnit("bytes")
            .publishPercentiles(0.5, 0.95)
            .register(registry);
    }

    public void record(long bytes) {
        requestSize.record(bytes);
    }
}
```

## Tagging Conventions

### Rules
- **Lowercase, dot-separated** metric names: `orders.created`, `payment.processing`
- **Low cardinality** tags only: `status`, `method`, `outcome`, `type`
- **NEVER** use high-cardinality values as tags: user IDs, request IDs, email addresses
- **Consistent** tag keys across metrics for dashboard filtering

### Standard Tags
| Tag | Values | Example |
|-----|--------|---------|
| `outcome` | `success`, `failure` | Business operation result |
| `status` | HTTP status code | `200`, `400`, `500` |
| `method` | HTTP method | `GET`, `POST` |
| `uri` | Templated URI | `/api/v1/orders/{id}` |
| `exception` | Exception class name | `TimeoutException` |

## Observation API (Micrometer 1.10+)

The Observation API combines metrics and tracing:
```java
@Service
public class OrderService {
    private final ObservationRegistry observationRegistry;

    public Order createOrder(OrderRequest request) {
        return Observation.createNotStarted("order.creation", observationRegistry)
            .lowCardinalityKeyValue("type", request.type().name())
            .observe(() -> doCreateOrder(request));
    }
}
```

## SLO-Based Alerting

Define Service Level Objectives and derive alerts:

| SLO | Metric | Alert Threshold |
|-----|--------|-----------------|
| 99.9% availability | `http.server.requests{status!=5xx}` / total | Error rate > 0.1% for 5 min |
| p99 latency < 500ms | `http.server.requests{quantile=0.99}` | p99 > 500ms for 5 min |
| Order success > 99% | `orders.created{outcome=success}` / total | Failure rate > 1% for 5 min |

## Prometheus Integration

### Scrape Configuration
```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'spring-boot-app'
    metrics_path: /actuator/prometheus
    scrape_interval: 15s
    static_configs:
      - targets: ['app:8080']
```

### Common PromQL Queries
```promql
# Request rate
rate(http_server_requests_seconds_count{uri="/api/v1/orders"}[5m])

# Error rate percentage
rate(http_server_requests_seconds_count{status=~"5.."}[5m])
/ rate(http_server_requests_seconds_count[5m]) * 100

# p95 latency
histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))

# Custom business metric rate
rate(orders_created_total{outcome="success"}[5m])
```

## Testing Metrics

```java
@SpringBootTest
class OrderServiceMetricsTest {
    @Autowired private OrderService orderService;
    @Autowired private MeterRegistry meterRegistry;

    @Test
    void shouldIncrementOrderCounter() {
        orderService.createOrder(validRequest());

        var counter = meterRegistry.find("orders.created")
            .tag("outcome", "success").counter();
        assertThat(counter).isNotNull();
        assertThat(counter.count()).isEqualTo(1.0);
    }

    @Test
    void shouldRecordPaymentTimer() {
        paymentService.process(validPayment());

        var timer = meterRegistry.find("payment.processing").timer();
        assertThat(timer).isNotNull();
        assertThat(timer.count()).isEqualTo(1);
        assertThat(timer.totalTime(TimeUnit.MILLISECONDS)).isGreaterThan(0);
    }
}
```
