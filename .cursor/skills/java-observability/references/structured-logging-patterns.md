# Structured Logging Patterns

Structured logging outputs log events as machine-parseable records (typically JSON) rather than free-text messages, enabling efficient search, filtering, and aggregation in centralized logging systems.

## Why Structured Logging

- **Searchable**: Filter by field (`userId`, `orderId`, `traceId`) instead of regex on text
- **Aggregatable**: Count errors by type, calculate latency percentiles
- **Correlatable**: Link logs across services using trace/span IDs
- **AI-friendly**: Structured data is easier for automated analysis tools

## Spring Boot Configuration

### Logback (JSON via logstash-logback-encoder)

```xml
<!-- logback-spring.xml -->
<configuration>
  <appender name="JSON" class="ch.qos.logback.core.ConsoleAppender">
    <encoder class="net.logstash.logback.encoder.LogstashEncoder">
      <includeMdcKeyName>traceId</includeMdcKeyName>
      <includeMdcKeyName>spanId</includeMdcKeyName>
      <includeMdcKeyName>userId</includeMdcKeyName>
    </encoder>
  </appender>

  <root level="INFO">
    <appender-ref ref="JSON"/>
  </root>
</configuration>
```

### Output Example

```json
{
  "@timestamp": "2026-04-22T10:30:00.000Z",
  "level": "INFO",
  "logger_name": "com.example.OrderService",
  "message": "Order processed",
  "orderId": "ORD-123",
  "customerId": "CUST-456",
  "totalAmount": 99.99,
  "processingTimeMs": 45,
  "traceId": "abc123",
  "spanId": "def456"
}
```

## MDC (Mapped Diagnostic Context)

Use MDC to add contextual data to all log statements within a scope:

```java
@Component
public class CorrelationFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        try {
            MDC.put("requestId", UUID.randomUUID().toString());
            MDC.put("userId", extractUserId((HttpServletRequest) req));
            chain.doFilter(req, res);
        } finally {
            MDC.clear();
        }
    }
}
```

## Structured Log Fields

### Standard Fields (always include)

| Field | Purpose |
|-------|---------|
| `timestamp` | Event time (ISO-8601) |
| `level` | Log level (ERROR, WARN, INFO, DEBUG) |
| `logger` | Source class |
| `message` | Human-readable description |
| `traceId` | Distributed trace correlation |
| `spanId` | Current span within trace |

### Business Context Fields (add per operation)

| Field | Purpose |
|-------|---------|
| `userId` | Current user |
| `orderId` | Business entity ID |
| `operation` | What is being done |
| `durationMs` | Operation time |
| `outcome` | success / failure |

## Key-Value Logging with SLF4J 2.0

```java
import org.slf4j.Logger;
import static org.slf4j.LoggerFactory.getLogger;

private static final Logger log = getLogger(OrderService.class);

log.atInfo()
   .addKeyValue("orderId", orderId)
   .addKeyValue("customerId", customerId)
   .addKeyValue("amount", totalAmount)
   .log("Order processed successfully");
```

## Anti-Patterns

- **Unstructured exceptions**: Always include the exception object as the last SLF4J argument
- **Sensitive data in logs**: Never log passwords, tokens, PII without masking
- **Log-and-throw**: Do not log an exception and then rethrow it (causes duplicate entries)
- **String concatenation**: Use parameterized messages (`{}`) or key-value pairs
- **Missing correlation**: Always propagate `traceId` in inter-service calls

## Integration with Observability Stack

| Tool | Purpose |
|------|---------|
| ELK (Elasticsearch, Logstash, Kibana) | Log aggregation and search |
| Grafana Loki | Lightweight log aggregation |
| Micrometer Tracing | Automatic `traceId`/`spanId` injection |
| Spring Boot Actuator | Log level management at runtime |
