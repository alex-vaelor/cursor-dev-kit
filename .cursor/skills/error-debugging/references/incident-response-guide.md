# Incident Response Guide for Java/Spring Boot Applications

## Incident Response Phases

### Phase 1: Detection & Alert
- Monitor dashboards: Spring Boot Actuator `/health`, `/metrics`
- Alerts from Micrometer/Prometheus (error rate, latency spikes, 5xx surge)
- Application logs: structured JSON logs in production
- User reports: support tickets, error reports

### Phase 2: Triage (First 5 Minutes)

**Severity Classification**

| Severity | Criteria | Response Time |
|----------|----------|---------------|
| SEV-1 | Production down, data loss, security breach | Immediate, all hands |
| SEV-2 | Major feature broken, significant user impact | <30 minutes |
| SEV-3 | Partial degradation, workaround exists | <4 hours |
| SEV-4 | Minor issue, cosmetic, no user impact | Next business day |

**Quick Diagnostic Checklist**
```bash
# Check application health
curl -s http://localhost:8080/actuator/health | jq .

# Check recent error logs (last 15 minutes)
# Structured JSON logging:
grep '"level":"ERROR"' /var/log/app/application.log | tail -20

# Check JVM state
jcmd <pid> VM.info
jcmd <pid> GC.heap_info

# Check thread state
jcmd <pid> Thread.print | grep -c "BLOCKED"
jcmd <pid> Thread.print | grep -c "WAITING"
```

### Phase 3: Contain & Mitigate
- **Rollback**: If the incident started after a deployment, rollback immediately
- **Feature flag**: Disable the affected feature if possible
- **Scale**: Add instances if the issue is load-related
- **Circuit breaker**: Verify Resilience4j circuit breakers are opening for failed dependencies
- **Rate limit**: Reduce traffic if the system is overwhelmed

### Phase 4: Root Cause Analysis

#### Correlation ID Tracing (Spring MDC)
```java
@Component
public class CorrelationFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain chain) throws ServletException, IOException {
        String correlationId = request.getHeader("X-Correlation-ID");
        if (correlationId == null) {
            correlationId = UUID.randomUUID().toString();
        }
        MDC.put("correlationId", correlationId);
        response.setHeader("X-Correlation-ID", correlationId);
        try {
            chain.doFilter(request, response);
        } finally {
            MDC.remove("correlationId");
        }
    }
}
```

Logback configuration for structured output:
```xml
<appender name="JSON" class="ch.qos.logback.core.ConsoleAppender">
  <encoder class="net.logstash.logback.encoder.LogstashEncoder">
    <includeMdcKeyName>correlationId</includeMdcKeyName>
    <includeMdcKeyName>userId</includeMdcKeyName>
  </encoder>
</appender>
```

Search by correlation ID:
```bash
# Grep across services
grep '"correlationId":"abc-123"' /var/log/*/application.log

# Elasticsearch/OpenSearch query
curl -s "http://es:9200/app-logs/_search?q=correlationId:abc-123" | jq .
```

#### 5 Whys Analysis Template
```markdown
**Incident**: Orders failing with 500 error since 14:30 UTC

1. Why did orders fail?
   → PaymentService threw TimeoutException

2. Why did PaymentService time out?
   → External payment gateway response time exceeded 5s timeout

3. Why was the gateway slow?
   → Gateway undergoing maintenance; 50% of requests taking >10s

4. Why didn't the circuit breaker open?
   → Circuit breaker threshold was set to 80% failure rate; actual was 60%

5. Why was the threshold so high?
   → Default Resilience4j config was never tuned for this service

**Root cause**: Circuit breaker threshold too aggressive for payment-critical path.
**Fix**: Lower failure rate threshold to 30%; add latency-based circuit breaking.
**Prevention**: Review all circuit breaker configs quarterly; add latency alerting.
```

#### Spring Boot Actuator Diagnostics
```bash
# Metrics: request rate, error rate, latency percentiles
curl -s http://localhost:8080/actuator/metrics/http.server.requests | jq .

# Specific endpoint metrics
curl -s 'http://localhost:8080/actuator/metrics/http.server.requests?tag=uri:/api/v1/orders&tag=status:500' | jq .

# Health check with details
curl -s http://localhost:8080/actuator/health | jq .

# Environment (check config)
curl -s http://localhost:8080/actuator/env/spring.datasource.url | jq .

# Thread dump (via Actuator)
curl -s http://localhost:8080/actuator/threaddump | jq '.threads | length'
```

### Phase 5: Resolution & Communication

**Status Update Template**
```markdown
**Incident**: [Title]
**Status**: Investigating / Identified / Monitoring / Resolved
**Impact**: [Who is affected and how]
**Start time**: [YYYY-MM-DD HH:MM UTC]
**Duration**: [Time since start]

**Current actions**:
- [What is being done]
- [ETA for resolution]

**Next update**: [Time of next update]
```

### Phase 6: Post-Incident Review

**Post-Mortem Template**
```markdown
## Post-Mortem: [Incident Title]

**Date**: YYYY-MM-DD
**Duration**: X hours Y minutes
**Severity**: SEV-1/2/3/4
**Impact**: [Users affected, data impact, revenue impact]

### Timeline
| Time (UTC) | Event |
|------------|-------|
| 14:30 | Monitoring alert: 5xx rate >5% |
| 14:35 | On-call engineer paged |
| 14:40 | Root cause identified: DB connection pool exhausted |
| 14:45 | Mitigation: Increased pool size, restarted |
| 15:00 | Service recovered |

### Root Cause
[5 Whys analysis]

### What Went Well
- Alert fired within 5 minutes
- Rollback was fast

### What Went Wrong
- Connection pool not monitored
- No runbook for DB connection issues

### Action Items
| Action | Owner | Due Date |
|--------|-------|----------|
| Add connection pool metrics to dashboard | @ops | YYYY-MM-DD |
| Create DB connection troubleshooting runbook | @lead | YYYY-MM-DD |
| Lower circuit breaker threshold for payment | @dev | YYYY-MM-DD |
```

## Key Spring Boot Monitoring Points

| Metric | Actuator Endpoint | Alert Threshold |
|--------|-------------------|-----------------|
| Error rate | `http.server.requests{status=5xx}` | >1% of total requests |
| Latency p99 | `http.server.requests{quantile=0.99}` | >2x baseline |
| DB connection pool | `hikaricp.connections.active` | >80% of max pool |
| JVM heap | `jvm.memory.used{area=heap}` | >80% of max |
| Thread count | `jvm.threads.live` | >2x baseline |
| Circuit breaker open | `resilience4j.circuitbreaker.state` | Any OPEN state |
