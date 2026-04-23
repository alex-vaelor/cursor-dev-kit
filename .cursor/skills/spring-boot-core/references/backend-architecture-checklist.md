# Backend Architecture Checklist for Spring Boot

## Purpose

Comprehensive checklist for backend capabilities when designing or reviewing a Spring Boot application. Use as a handoff guide or architecture review aid.

## Core Application Layer

### API Layer
- [ ] REST controllers follow resource-oriented design
- [ ] OpenAPI annotations on all public endpoints
- [ ] Request validation with `@Valid` and Jakarta Bean Validation
- [ ] Error responses use RFC 9457 Problem Detail (`ProblemDetail`)
- [ ] API versioning strategy defined (URI or header-based)
- [ ] Rate limiting configured (Bucket4j or Resilience4j)
- [ ] CORS configured for known origins only
- [ ] Content negotiation for JSON (default) and other formats

### Service Layer
- [ ] Business logic isolated from framework concerns
- [ ] Constructor injection with `@RequiredArgsConstructor` or explicit constructors
- [ ] Transaction boundaries defined with `@Transactional`
- [ ] Domain events for cross-concern communication
- [ ] Idempotency support for critical operations
- [ ] Retry logic for transient failures (Resilience4j `@Retry`)

### Data Access Layer
- [ ] Spring Data JPA for standard CRUD
- [ ] `JdbcClient` for complex/bulk queries
- [ ] Entity design follows JPA best practices (business key, lazy loading)
- [ ] Flyway migrations for schema changes
- [ ] Connection pool tuned (HikariCP defaults reviewed)
- [ ] Read replicas for heavy read workloads

## Cross-Cutting Concerns

### Security
- [ ] Spring Security `SecurityFilterChain` configured
- [ ] JWT or OAuth2 for API authentication
- [ ] Method-level authorization (`@PreAuthorize`, `@Secured`)
- [ ] CSRF protection for browser-facing endpoints
- [ ] Secrets managed via environment variables or vault
- [ ] OWASP Top 10 mitigations in place
- [ ] Dependency vulnerability scanning (OWASP Dependency-Check)

### Observability
- [ ] Structured logging (SLF4J + Logback, JSON format in production)
- [ ] Correlation IDs via MDC (propagated across threads)
- [ ] Spring Boot Actuator enabled (health, metrics, info)
- [ ] Micrometer metrics for business KPIs
- [ ] Distributed tracing (Micrometer Tracing + Zipkin/Jaeger)
- [ ] Health checks: liveness and readiness probes for Kubernetes
- [ ] Alerting thresholds defined for key metrics

### Resilience
- [ ] Circuit breakers for external calls (Resilience4j `@CircuitBreaker`)
- [ ] Retry with exponential backoff for transient failures
- [ ] Bulkhead isolation for critical paths
- [ ] Timeout configuration for all external calls
- [ ] Graceful shutdown (`server.shutdown=graceful`)
- [ ] Fallback strategies defined for degraded operations

### Configuration
- [ ] Externalized configuration via `application.yml` + profiles
- [ ] `@ConfigurationProperties` with `@Validated` for type-safe config
- [ ] Secrets not in configuration files (use env vars / vault)
- [ ] Feature flags for incremental rollouts
- [ ] Environment-specific profiles (`dev`, `staging`, `prod`)

## Infrastructure

### Build & CI
- [ ] Maven wrapper committed (`./mvnw`)
- [ ] Reproducible builds (dependency lock, BOM versions)
- [ ] Quality gates: Checkstyle, SpotBugs, JaCoCo in CI
- [ ] Docker multi-stage build for optimized images
- [ ] GitHub Actions or equivalent CI pipeline

### Deployment
- [ ] Docker image with non-root user, distroless or Eclipse Temurin base
- [ ] JVM tuning (`-XX:MaxRAMPercentage`, `-XX:+UseZGC`)
- [ ] Kubernetes manifests or Helm charts
- [ ] Health endpoints for liveness/readiness probes
- [ ] Rolling deployment strategy
- [ ] Database migration runs before application startup

### Testing
- [ ] Unit tests for service/domain logic (JUnit 5)
- [ ] Slice tests for web (`@WebMvcTest`) and data (`@DataJpaTest`) layers
- [ ] Integration tests with Testcontainers
- [ ] Contract tests for API consumers (Spring Cloud Contract or Pact)
- [ ] Performance baselines established
- [ ] Test coverage >80% line coverage

## Architecture Decision Records

For each significant choice, document:
- What was decided and why
- What alternatives were considered
- What trade-offs were accepted
- When to revisit (triggers for re-evaluation)

See `skills/architecture-design/references/adr-template.md` for the template.
