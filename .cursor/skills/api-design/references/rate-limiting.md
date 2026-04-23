# Rate Limiting Patterns for Spring Boot APIs

## Why Rate Limit

- Prevent abuse and denial-of-service attacks
- Protect downstream services from overload
- Enforce fair usage policies for API consumers
- Maintain consistent performance under load

## Algorithms

| Algorithm | Behavior | Use Case |
|-----------|----------|----------|
| **Fixed window** | Count resets at fixed intervals | Simple, approximate |
| **Sliding window** | Rolling count over trailing period | Smoother, prevents burst at window boundary |
| **Token bucket** | Tokens replenish at fixed rate; burst allowed up to bucket size | Best for APIs: allows bursts with sustained limit |
| **Leaky bucket** | Requests processed at fixed rate; excess queued or rejected | Smooth output rate |

## Bucket4j + Spring Boot

### Dependency
```xml
<dependency>
  <groupId>com.bucket4j</groupId>
  <artifactId>bucket4j-core</artifactId>
  <version>8.10.1</version>
</dependency>
```

### Per-Client Rate Limiting
```java
@Component
public class RateLimitFilter extends OncePerRequestFilter {
    private final ConcurrentMap<String, Bucket> buckets = new ConcurrentHashMap<>();

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain chain) throws ServletException, IOException {
        String clientId = resolveClientId(request);
        Bucket bucket = buckets.computeIfAbsent(clientId, this::createBucket);

        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);

        response.setHeader("X-Rate-Limit-Remaining", String.valueOf(probe.getRemainingTokens()));

        if (probe.isConsumed()) {
            chain.doFilter(request, response);
        } else {
            long waitSeconds = probe.getNanosToWaitForRefill() / 1_000_000_000;
            response.setHeader("Retry-After", String.valueOf(waitSeconds));
            response.setStatus(HttpServletResponse.SC_TOO_MANY_REQUESTS);
            response.getWriter().write("""
                {"type":"https://api.example.com/errors/rate-limit",\
                "title":"Rate Limit Exceeded",\
                "status":429,\
                "detail":"Too many requests. Retry after %d seconds."}
                """.formatted(waitSeconds));
        }
    }

    private Bucket createBucket(String clientId) {
        return Bucket.builder()
            .addLimit(BandwidthBuilder.builder()
                .capacity(100)
                .refillGreedy(100, Duration.ofMinutes(1))
                .build())
            .build();
    }

    private String resolveClientId(HttpServletRequest request) {
        String apiKey = request.getHeader("X-API-Key");
        if (apiKey != null) return "key:" + apiKey;

        String jwt = request.getHeader("Authorization");
        if (jwt != null) return "jwt:" + extractSubject(jwt);

        return "ip:" + request.getRemoteAddr();
    }
}
```

## Resilience4j Rate Limiter

For simpler use cases with annotation-based configuration:

```java
@RestController
@RequestMapping("/api/v1/search")
public class SearchController {

    @RateLimiter(name = "searchApi", fallbackMethod = "searchRateLimited")
    @GetMapping
    public ResponseEntity<SearchResults> search(@RequestParam String query) {
        return ResponseEntity.ok(searchService.search(query));
    }

    private ResponseEntity<SearchResults> searchRateLimited(String query, RequestNotPermitted ex) {
        return ResponseEntity.status(429)
            .header("Retry-After", "60")
            .body(SearchResults.empty());
    }
}
```

```yaml
resilience4j:
  ratelimiter:
    instances:
      searchApi:
        limit-for-period: 100
        limit-refresh-period: 1m
        timeout-duration: 0s
```

## Tiered Rate Limits

| Tier | Rate | Burst | Identification |
|------|------|-------|---------------|
| Anonymous | 10 req/min | 20 | IP address |
| Free tier | 100 req/min | 200 | API key |
| Pro tier | 1000 req/min | 2000 | API key |
| Internal service | 10000 req/min | 20000 | mTLS certificate |

```java
private Bucket createBucket(String clientId) {
    var tier = apiKeyService.getTier(clientId);
    return switch (tier) {
        case FREE -> createBucketWithLimit(100, Duration.ofMinutes(1));
        case PRO -> createBucketWithLimit(1000, Duration.ofMinutes(1));
        case INTERNAL -> createBucketWithLimit(10000, Duration.ofMinutes(1));
    };
}
```

## Distributed Rate Limiting

For multi-instance deployments, use Redis-backed Bucket4j:

```xml
<dependency>
  <groupId>com.bucket4j</groupId>
  <artifactId>bucket4j-redis</artifactId>
  <version>8.10.1</version>
</dependency>
```

```java
@Bean
public ProxyManager<String> proxyManager(LettuceBasedProxyManager.LettuceBasedProxyManagerBuilder<String> builder) {
    return builder.build();
}
```

## Response Headers

Always include rate limit info in responses:

| Header | Value | Purpose |
|--------|-------|---------|
| `X-Rate-Limit-Limit` | 100 | Max requests per window |
| `X-Rate-Limit-Remaining` | 73 | Remaining requests in current window |
| `X-Rate-Limit-Reset` | 1619472000 | Unix timestamp when window resets |
| `Retry-After` | 30 | Seconds until next request allowed (on 429) |

## Testing Rate Limits

```java
@Test
void shouldReturn429WhenRateLimitExceeded() throws Exception {
    for (int i = 0; i < 100; i++) {
        mockMvc.perform(get("/api/v1/search").param("query", "test"))
            .andExpect(status().isOk());
    }

    mockMvc.perform(get("/api/v1/search").param("query", "test"))
        .andExpect(status().isTooManyRequests())
        .andExpect(header().exists("Retry-After"));
}
```
