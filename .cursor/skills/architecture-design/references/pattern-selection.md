# Architecture Pattern Selection

## Purpose

Provide decision trees and comparison matrices for selecting architectural patterns based on system requirements, team context, and quality attributes.

## Decision Tree: Application Architecture

```
Start
 ├─ Single team, bounded domain?
 │   ├─ Yes → Modular Monolith
 │   └─ No → Multiple teams?
 │       ├─ Yes, independent release cycles → Microservices
 │       └─ Yes, shared release cycle → Modular Monolith with clear module boundaries
 │
 ├─ Complex business rules with deep domain model?
 │   ├─ Yes → Hexagonal Architecture (ports & adapters)
 │   └─ No, mostly CRUD → Layered Architecture
 │
 ├─ High read:write ratio (>10:1)?
 │   ├─ Yes → CQRS (separate read/write models)
 │   └─ No → Standard single model
 │
 ├─ Need audit trail / temporal queries?
 │   ├─ Yes → Event Sourcing
 │   └─ No → State-based persistence
 │
 ├─ Cross-service transactions required?
 │   ├─ Yes → Saga Pattern (orchestration or choreography)
 │   └─ No → Direct service calls or messaging
```

## Pattern Comparison Matrix

| Pattern | Complexity | Scalability | Testability | Team Size | Best For |
|---------|-----------|-------------|-------------|-----------|----------|
| **Layered** | Low | Moderate | Good | 1-5 | Simple CRUD, admin panels |
| **Hexagonal** | Medium | Good | Excellent | 3-10 | Complex domain logic |
| **CQRS** | Medium-High | Excellent (reads) | Good | 5-15 | Read-heavy workloads |
| **Event Sourcing** | High | Excellent | Complex | 5-20 | Audit, temporal queries |
| **Modular Monolith** | Medium | Good | Excellent | 3-15 | Growing domain, single deployment |
| **Microservices** | Very High | Excellent | Complex | 10+ | Independent team scaling |

## Decision Tree: Data Access Pattern

```
Start
 ├─ Simple CRUD operations?
 │   ├─ Yes → Spring Data JPA repositories (interface-only)
 │   └─ No → Complex queries needed?
 │       ├─ Dynamic filtering → Spring Data Specifications
 │       ├─ Complex joins → JPQL / @Query
 │       ├─ Bulk operations → Native SQL or JdbcClient
 │       └─ Read projections → Interface-based projections or records
```

## Decision Tree: Communication Pattern

```
Start
 ├─ Synchronous required (needs response)?
 │   ├─ Internal service → REST or gRPC
 │   └─ External → REST (standard) or SOAP (legacy)
 │
 ├─ Asynchronous (fire and forget)?
 │   ├─ Ordering required → Kafka (partition-keyed)
 │   ├─ Fan-out needed → RabbitMQ (topic exchange) or SNS
 │   └─ Scheduled → Spring @Scheduled or Quartz
 │
 ├─ Request-reply async?
 │   └─ Spring Cloud Stream with reply channel
```

## Spring Boot 4 Pattern Implementation Guide

### Layered Architecture
```
com.example.app/
├── web/                 # @RestController -- HTTP layer
│   ├── OrderController.java
│   └── dto/             # Request/response records
├── service/             # @Service -- business logic
│   └── OrderService.java
├── repository/          # @Repository -- data access
│   └── OrderRepository.java
└── domain/              # Entities, value objects
    └── Order.java
```

### Hexagonal Architecture
```
com.example.app/
├── domain/              # Core domain -- no framework dependencies
│   ├── model/           # Aggregates, entities, value objects
│   ├── port/            # Input (use case) and output (SPI) interfaces
│   └── service/         # Domain services
├── application/         # Use case orchestration
│   └── OrderUseCase.java
├── adapter/
│   ├── in/              # Driving adapters
│   │   └── web/         # REST controllers
│   └── out/             # Driven adapters
│       ├── persistence/ # JPA repositories
│       └── messaging/   # Kafka producers
└── config/              # Spring configuration
```

### Modular Monolith
```
com.example.app/
├── order/               # Order bounded context
│   ├── api/             # Public interface (events, DTOs)
│   ├── internal/        # Private implementation
│   └── OrderModuleConfig.java
├── inventory/           # Inventory bounded context
│   ├── api/
│   └── internal/
├── shared/              # Shared kernel
│   └── DomainEvent.java
└── Application.java
```

## Anti-Pattern: Wrong Pattern for the Context

| Situation | Wrong Choice | Why | Better Choice |
|-----------|-------------|-----|---------------|
| 3-person team, single domain | Microservices | Operational overhead, distributed complexity | Modular monolith |
| CRUD admin panel | Hexagonal architecture | Over-engineering; no complex domain | Layered architecture |
| 100 writes/sec, 10 reads/sec | CQRS | Complexity without read scaling benefit | Single model |
| No audit requirements | Event sourcing | Rebuild complexity without business need | State-based persistence |
