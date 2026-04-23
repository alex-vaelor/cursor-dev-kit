# Retry Patterns for Spring Boot

## Spring Retry Setup

### Dependency
```xml
<dependency>
  <groupId>org.springframework.retry</groupId>
  <artifactId>spring-retry</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-aspects</artifactId>
</dependency>
```

### Enable
```java
@Configuration
@EnableRetry
public class RetryConfig { }
```

## Declarative Retry (@Retryable)

### Basic Configuration
```java
@Service
public class ExternalApiClient {

    @Retryable(
        retryFor = {ConnectException.class, SocketTimeoutException.class},
        noRetryFor = {HttpClientErrorException.BadRequest.class},
        maxAttempts = 3,
        backoff = @Backoff(delay = 1000, multiplier = 2.0, maxDelay = 10000)
    )
    public ApiResponse callExternalService(ApiRequest request) {
        return restClient.post()
            .uri("/api/process")
            .body(request)
            .retrieve()
            .body(ApiResponse.class);
    }

    @Recover
    public ApiResponse recover(ConnectException ex, ApiRequest request) {
        log.error("External service unreachable after retries: {}", ex.getMessage());
        return ApiResponse.unavailable(request.correlationId());
    }

    @Recover
    public ApiResponse recover(SocketTimeoutException ex, ApiRequest request) {
        log.error("External service timed out after retries: {}", ex.getMessage());
        return ApiResponse.timeout(request.correlationId());
    }
}
```

### Backoff Strategies

| Strategy | Configuration | Use Case |
|----------|--------------|----------|
| Fixed | `@Backoff(delay = 1000)` | Simple, predictable |
| Exponential | `@Backoff(delay = 1000, multiplier = 2.0)` | Reduces thundering herd |
| Exponential with jitter | `@Backoff(delay = 1000, multiplier = 2.0, random = true)` | Best for distributed systems |
| Capped exponential | `@Backoff(delay = 1000, multiplier = 2.0, maxDelay = 30000)` | Prevents excessive waits |

## Programmatic Retry (RetryTemplate)

```java
@Bean
public RetryTemplate retryTemplate() {
    return RetryTemplate.builder()
        .maxAttempts(3)
        .exponentialBackoff(1000, 2.0, 10000)
        .retryOn(ConnectException.class)
        .retryOn(SocketTimeoutException.class)
        .traversingCauses()
        .build();
}

@Service
public class PaymentService {
    private final RetryTemplate retryTemplate;
    private final PaymentGateway gateway;

    public PaymentResult processPayment(PaymentRequest request) {
        return retryTemplate.execute(
            ctx -> gateway.charge(request),
            ctx -> {
                log.error("Payment failed after {} attempts", ctx.getRetryCount());
                return PaymentResult.queued(request.orderId());
            }
        );
    }
}
```

## Spring Retry vs Resilience4j

| Aspect | Spring Retry | Resilience4j |
|--------|-------------|--------------|
| **Focus** | Retry only | Retry, circuit breaker, bulkhead, rate limiter, time limiter |
| **Configuration** | Annotations + properties | Annotations + YAML + programmatic |
| **Metrics** | Manual | Built-in Micrometer integration |
| **Circuit breaker** | Not included | Included |
| **Best for** | Simple retry needs | Comprehensive resilience |
| **Combine** | Use Spring Retry for simple retries | Add Resilience4j when circuit breaking needed |

### Combining Spring Retry + Resilience4j
```java
@CircuitBreaker(name = "paymentGateway", fallbackMethod = "fallback")
@Retryable(maxAttempts = 3, backoff = @Backoff(delay = 500))
public PaymentResult charge(PaymentRequest request) {
    return gateway.charge(request);
}
```
Order: Retry executes inside the circuit breaker. If retries exhausted, circuit breaker sees the failure.

## Idempotency Requirements

**Rule**: Only retry operations that are safe to execute multiple times.

| Operation Type | Idempotent? | Retry Safe? |
|---------------|-------------|-------------|
| GET / read | Yes | Always safe |
| DELETE by ID | Yes (result is same) | Safe |
| PUT (full replace) | Yes | Safe |
| POST (create) | No | Needs idempotency key |
| Payment charge | No | Needs idempotency key |

### Idempotency Key Pattern
```java
@Retryable(maxAttempts = 3, backoff = @Backoff(delay = 1000))
public PaymentResult processPayment(UUID idempotencyKey, PaymentRequest request) {
    var existing = idempotencyStore.find(idempotencyKey);
    if (existing.isPresent()) return existing.get();

    var result = gateway.charge(request);
    idempotencyStore.save(idempotencyKey, result);
    return result;
}
```

## Exception Classification

```java
@Retryable(
    retryFor = {
        ConnectException.class,          // network unreachable
        SocketTimeoutException.class,    // read timeout
        OptimisticLockingFailureException.class,  // concurrent modification
        TransientDataAccessException.class         // temporary DB issue
    },
    noRetryFor = {
        BusinessValidationException.class,  // permanent business error
        HttpClientErrorException.class,     // 4xx -- client error
        DataIntegrityViolationException.class  // constraint violation
    }
)
```

## Testing Retry

```java
@SpringBootTest
class ExternalApiClientTest {
    @MockBean private RestClient restClient;
    @Autowired private ExternalApiClient client;

    @Test
    void shouldRetryOnTimeout() {
        given(restClient.post().retrieve().body(ApiResponse.class))
            .willThrow(new SocketTimeoutException("Timeout"))
            .willThrow(new SocketTimeoutException("Timeout"))
            .willReturn(ApiResponse.success());

        var result = client.callExternalService(request);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void shouldRecoverAfterMaxAttempts() {
        given(restClient.post().retrieve().body(ApiResponse.class))
            .willThrow(new ConnectException("Refused"));

        var result = client.callExternalService(request);

        assertThat(result.isUnavailable()).isTrue();
    }
}
```

## Retry Observability
Log retry attempts for monitoring:
```java
@Bean
public RetryListenerSupport retryListener() {
    return new RetryListenerSupport() {
        @Override
        public <T, E extends Throwable> void onError(RetryContext ctx, RetryCallback<T, E> cb, Throwable t) {
            log.warn("Retry attempt {} for {}: {}",
                ctx.getRetryCount(), ctx.getAttribute("context.name"), t.getMessage());
        }
    };
}
```
