# Supported Version Matrix

Last updated: 2026-04-22

## Primary Baseline (Recommended)

| Component | Version | Status | Notes |
|-----------|---------|--------|-------|
| Java | **21 LTS** | Recommended | Records, sealed classes, pattern matching, virtual threads, sequenced collections |
| Spring Framework | **7.0.7** | Current stable | Jakarta EE 11, JSpecify, Jackson 3.0, JUnit 6 baseline |
| Spring Boot | **4.0.5** | Current stable | Spring Framework 7 based, virtual threads support |
| Jakarta EE | **11** | Current | Servlet 6.1, JPA 3.2, Bean Validation 3.1 |
| JUnit | **6** | Current | Spring Framework 7 baseline; JUnit 5 remains supported for migration |
| Maven | **3.9.x** | Current stable | Maven Wrapper (`mvnw`) preferred |
| Gradle | **8.x** | Current stable | Kotlin DSL preferred for new projects |
| JaCoCo | **0.8.x** | Current stable | Code coverage |
| Checkstyle | **10.x** | Current stable | Google or project-specific config |
| SpotBugs | **4.x** | Current stable | Static analysis |
| Flyway | **10.x** | Current stable | Database migrations |
| Testcontainers | **1.20.x** | Current stable | Integration test containers |
| Lombok | **1.18.44+** | Current stable | Required for Spring Boot 4.0.x compatibility |
| OpenRewrite | **8.x** | Current stable | Automated migration recipes for Java/Spring upgrades |
| ArchUnit | **1.3.x** | Current stable | Architecture rule enforcement in tests |
| MapStruct | **1.6.x** | Current stable | Compile-time bean mapping |
| Spring Retry | **2.x** | Current stable | Declarative retry with `@Retryable` |
| Spring for GraphQL | **1.3.x** | Current stable | GraphQL API support |
| Bucket4j | **8.x** | Current stable | Rate limiting |
| Apache Commons Lang | **3.17.x** | Current stable | Use selectively; prefer JDK 17+ equivalents |
| Micrometer | **1.14.x** | Current stable | Metrics and observability |
| Hibernate Validator | **9.x** | Current stable | Jakarta Bean Validation implementation |
| Lettuce (Redis) | **6.x** | Current stable | Redis client for Spring Data Redis |
| Caffeine | **3.x** | Current stable | High-performance local cache |
| Resilience4j | **2.x** | Current stable | Circuit breaker, retry, rate limiter |
| Hibernate ORM | **7.0.x** | Current stable | JPA implementation for Spring Boot 4.x / Jakarta JPA 3.2 |
| Spring Data Envers | **3.x** | Current stable | Hibernate Envers integration for Spring Data repositories |

## Compatibility Baseline (Supported)

For projects not yet migrated to the primary baseline:

| Component | Version | Status | Migration Path |
|-----------|---------|--------|----------------|
| Java | **17 LTS** | Supported (minimum) | See `skills/java-modernization/references/migration-java-17-to-21.md` |
| Spring Framework | **6.2.x** | Supported | Upgrade to 7.0 when ready |
| Spring Boot | **3.4.x** | Supported | Upgrade to 4.0 when ready |
| Jakarta EE | **10** | Supported | Namespace already `jakarta.*` |
| JUnit | **5.11.x** | Supported | JUnit 6 is evolutionary, not breaking |
| Jackson | **2.18.x** | Supported | Spring Framework 7 supports both 2.x and 3.0 |

## Deprecated / Legacy (Avoid for New Projects)

| Component | Version | Status | Action Required |
|-----------|---------|--------|-----------------|
| Java | **8, 11** | Legacy | Migrate to 17+ immediately |
| Spring Boot | **2.x** | EOL | Migrate to 3.x then 4.x |
| `javax.*` namespace | Pre-Jakarta | Removed in Spring Framework 7 | Replace with `jakarta.*` |
| `ListenableFuture` | Spring 5 era | Removed in Spring Framework 7 | Replace with `CompletableFuture` |
| Jackson | **2.x** | Deprecated in Spring 7 | Move to Jackson 3.0 |
| JUnit | **4** | Legacy | Migrate to JUnit 5+ using `junit-vintage-engine` bridge |
| Undertow | -- | Removed in Spring Framework 7 | Use Tomcat or Netty |

## Key Version Interactions

```
Java 21 ─── Spring Framework 7.0.7 ─── Spring Boot 4.0.5
                │                           │
                ├── Jakarta EE 11           ├── Spring Security 7.x
                ├── JSpecify (null safety)  ├── Spring Data 2026.x
                ├── Jackson 3.0             ├── Flyway 10.x
                ├── JUnit 6                 └── Testcontainers 1.20.x
                └── Kotlin 2.2 (optional)
```

## Compatibility Notes

### Java 17 to 21 Increments
- Java 17: sealed classes, pattern matching for instanceof (final)
- Java 19: virtual threads (preview)
- Java 20: record patterns (preview), scoped values (incubator)
- Java 21: virtual threads (final), record patterns (final), pattern matching for switch (final), sequenced collections

### Spring Framework 6 to 7 Breaking Changes
- Removed `javax.annotation` and `javax.inject` support
- Removed `ListenableFuture` (use `CompletableFuture`)
- Removed Undertow support
- Removed Spring JCL module
- Removed suffix pattern matching and trailing slash matching
- Jackson 3.0 as primary (2.x retained as deprecated fallback)
- JSpecify-based comprehensive null safety

### Spring Boot 3.x to 4.x Migration
- Spring Framework 7 required
- Jakarta EE 11 required
- Review `application.properties` for renamed/removed keys
- Update OpenAPI Generator to use `useSpringBoot4` flag
