---
name: spring-cache-retry
description: "Use when implementing caching or retry logic in Spring Boot -- including Spring Cache abstraction (@Cacheable, @CacheEvict), cache backends (Redis, Caffeine, ConcurrentMap), Spring Retry (@Retryable, @Recover, RetryTemplate), and retry vs circuit breaker decisions."
risk: safe
source: new
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: infrastructure
  triggers: cache, caching, @Cacheable, @CacheEvict, eviction, TTL, Redis cache, Caffeine, retry, @Retryable, @Recover, RetryTemplate, backoff, idempotent
  role: specialist
  scope: spring-cache-retry
  related-skills: spring-boot-core, java-exception-handling, spring-data-access
---

# Spring Cache & Retry

Implement caching strategies and retry logic for Spring Boot applications.

## When to Use This Skill

- Add caching to reduce database or external service load
- Choose between cache backends (ConcurrentMap, Caffeine, Redis)
- Design cache keys, TTL, and eviction strategies
- Implement retry logic for transient failures
- Choose between Spring Retry and Resilience4j
- Combine retry with circuit breaker patterns

## Cache Workflow

1. **Identify**: Find hot paths (frequent reads, expensive computations, external calls)
2. **Strategy**: Choose caching pattern (cache-aside, read-through, write-behind)
3. **Backend**: Select backend based on deployment (local vs distributed)
4. **Keys**: Design explicit cache keys with SpEL
5. **TTL**: Set per-cache TTL; never use unbounded caches
6. **Evict**: Ensure `@CacheEvict` on all write paths
7. **Test**: Verify cache hits, evictions, and TTL behavior

## Retry Workflow

1. **Classify**: Is the failure transient or permanent?
2. **Idempotent**: Is the operation safe to retry?
3. **Configure**: Set max attempts, backoff strategy, retryable exceptions
4. **Recover**: Define fallback with `@Recover`
5. **Test**: Verify retry count, backoff timing, and recovery

## Constraints

- **MANDATORY**: Run `./mvnw compile` before applying any change
- **NEVER** retry non-idempotent operations without an idempotency key
- **NEVER** cache without TTL in production
- **ALWAYS** test cache eviction paths

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Cache patterns and strategies | `references/cache-patterns.md` | Implementing caching |
| Retry patterns and configuration | `references/retry-patterns.md` | Implementing retry logic |

## Related Rules

- `rules/spring/retry-cache.mdc` -- retry and cache conventions
- `rules/spring/aop.mdc` -- AOP (cache/retry are AOP-based)

## Related Skills

- `skills/spring-boot-core/` -- Spring Boot fundamentals
- `skills/java-exception-handling/` -- exception handling and resilience
- `skills/spring-data-access/` -- data access (Redis)
