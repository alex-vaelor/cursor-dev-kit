# Architecture Patterns Quick Reference

## Pattern Summary Cards

### Layered Architecture

| Aspect | Detail |
|--------|--------|
| **Layers** | Presentation → Service → Data Access → Domain |
| **Rule** | Each layer depends only on the layer directly below |
| **Spring mapping** | `@RestController` → `@Service` → `@Repository` → Entity |
| **Pros** | Simple, well-understood, good tooling support |
| **Cons** | Can lead to anemic domain, tight vertical coupling |
| **Use when** | CRUD applications, admin panels, simple business logic |

### Hexagonal Architecture (Ports & Adapters)

| Aspect | Detail |
|--------|--------|
| **Core idea** | Domain logic at center; framework/infra at edges |
| **Ports** | Interfaces defined in domain (`OrderPort`, `PaymentGateway`) |
| **Adapters** | Implementations wired by Spring (`JpaOrderAdapter`, `StripeGateway`) |
| **Pros** | Framework-independent domain; excellent testability |
| **Cons** | More interfaces, indirection; overhead for simple CRUD |
| **Use when** | Complex business rules, need to swap infrastructure |

### CQRS (Command Query Responsibility Segregation)

| Aspect | Detail |
|--------|--------|
| **Core idea** | Separate models for reads and writes |
| **Write side** | Domain model, aggregate enforcement, event publication |
| **Read side** | Denormalized projections optimized for queries |
| **Spring mapping** | Write: `@Service` + JPA; Read: `JdbcClient` + projection records |
| **Pros** | Independent read/write scaling, optimized query models |
| **Cons** | Eventual consistency, projection maintenance, complexity |
| **Use when** | Read:write ratio >10:1, complex read requirements |

### Event Sourcing

| Aspect | Detail |
|--------|--------|
| **Core idea** | Store events, not state; rebuild state by replaying events |
| **Event store** | Append-only log of domain events |
| **Projection** | Materialized view rebuilt from events |
| **Snapshot** | Periodic state capture to avoid full replay |
| **Pros** | Complete audit trail, temporal queries, event-driven integration |
| **Cons** | Complex rebuilds, schema evolution, eventual consistency |
| **Use when** | Audit/compliance, temporal queries, event-driven architecture |

### Modular Monolith

| Aspect | Detail |
|--------|--------|
| **Core idea** | Single deployment, but internal module boundaries enforced |
| **Module boundary** | Java module system or package conventions + ArchUnit |
| **Communication** | Direct method calls or Spring application events |
| **Data** | Schema-per-module or table-prefix-per-module |
| **Pros** | Simple deployment, strong boundaries, can extract to microservices later |
| **Cons** | Shared JVM resources, single deployment cadence |
| **Use when** | Small-medium team, growing domain, want microservice structure without operational cost |

### Microservices

| Aspect | Detail |
|--------|--------|
| **Core idea** | Independent services, each owning its data and deployment |
| **Communication** | REST/gRPC (sync), Kafka/RabbitMQ (async) |
| **Data** | Database per service (strict ownership) |
| **Spring tools** | Spring Cloud Gateway, Config, Eureka, Resilience4j |
| **Pros** | Independent scaling, team autonomy, technology flexibility |
| **Cons** | Network complexity, distributed transactions, operational overhead |
| **Use when** | Multiple teams, independent release cycles, different scaling needs |

## Cross-Cutting Concerns by Pattern

| Concern | Layered | Hexagonal | CQRS | Event Sourcing | Microservices |
|---------|---------|-----------|------|----------------|---------------|
| Transaction mgmt | Spring `@Transactional` | Port-level txn boundary | Write-side only | Event store atomicity | Saga pattern |
| Testing | Slice tests | Port mocking | Separate command/query tests | Event replay tests | Contract tests |
| Caching | Service layer cache | Adapter cache | Read model IS the cache | Projection cache | Service-level cache |
| Security | Filter chain | Port-level auth | Separate auth per side | Event encryption | API Gateway + service auth |
| Observability | MDC + Actuator | Same | Separate read/write metrics | Event tracing | Distributed tracing (Micrometer) |
