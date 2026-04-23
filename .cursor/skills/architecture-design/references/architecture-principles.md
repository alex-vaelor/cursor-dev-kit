# Architecture Principles for Java/Spring Boot

## Clean Architecture

### The Dependency Rule
Dependencies point inward. Inner layers know nothing about outer layers.

```
Outer: Frameworks & Drivers (Spring, JPA, REST, Kafka)
  ↓
Middle: Interface Adapters (Controllers, Repositories, Gateways)
  ↓
Inner: Application (Use Cases, Application Services)
  ↓
Core: Domain (Entities, Value Objects, Domain Services, Domain Events)
```

### Spring Boot Mapping
```
com.example.app/
├── domain/              # Core -- ZERO framework dependencies
│   ├── model/           # Entities, value objects, aggregates (records, sealed types)
│   ├── port/            # Interfaces for outbound operations (repository, gateway)
│   └── service/         # Domain services (pure business logic)
├── application/         # Use case orchestration
│   └── usecase/         # Application services (call domain + ports)
├── adapter/
│   ├── in/              # Driving adapters
│   │   ├── web/         # @RestController (depends on application, not domain directly)
│   │   └── messaging/   # @KafkaListener
│   └── out/             # Driven adapters
│       ├── persistence/ # JPA/JDBC repository implementations
│       └── gateway/     # External service clients
└── config/              # Spring @Configuration, bean wiring
```

### Validation with ArchUnit
```java
@AnalyzeClasses(packages = "com.example.app")
class CleanArchitectureTest {
    @ArchTest
    static final ArchRule domain_should_not_depend_on_spring = noClasses()
        .that().resideInAPackage("..domain..")
        .should().dependOnClassesThat().resideInAPackage("org.springframework..");

    @ArchTest
    static final ArchRule domain_should_not_depend_on_adapters = noClasses()
        .that().resideInAPackage("..domain..")
        .should().dependOnClassesThat().resideInAPackage("..adapter..");
}
```

## SOLID at Architecture Level

### Single Responsibility (Service Boundaries)
Each service/module owns one business capability. Bounded contexts map to deployment units.

### Open/Closed (Extension Points)
Design systems that can be extended without modification:
- Plugin architecture (Spring auto-configuration)
- Event-driven extension (publish events, add listeners without changing publisher)
- Strategy injection (swap implementations via configuration)

### Liskov Substitution (Contract Compatibility)
API contracts must be backward-compatible:
- New fields are optional; existing fields keep their meaning
- New endpoints don't break existing ones
- Database migrations are expand-contract (never breaking)

### Interface Segregation (API Granularity)
- Fine-grained APIs: clients fetch only what they need
- BFF (Backend for Frontend) pattern when different clients need different shapes
- GraphQL as an alternative to over-fetching REST

### Dependency Inversion (Port/Adapter Architecture)
- Domain defines interfaces (ports); infrastructure implements them (adapters)
- Spring DI wires adapters to ports at runtime
- Enables testing domain logic without infrastructure

## 12-Factor App Methodology

| Factor | Spring Boot Implementation |
|--------|---------------------------|
| **1. Codebase** | One repo per deployable; Git |
| **2. Dependencies** | Maven/Gradle BOM; no system-level deps |
| **3. Config** | `application.yml` + env vars; `@ConfigurationProperties` |
| **4. Backing services** | DataSource, Redis, Kafka as injected beans |
| **5. Build, release, run** | `./mvnw clean package` -> Docker image -> deploy |
| **6. Processes** | Stateless; session in Redis, not memory |
| **7. Port binding** | Embedded Tomcat/Netty; `server.port` |
| **8. Concurrency** | Scale out via replicas; virtual threads for I/O |
| **9. Disposability** | Graceful shutdown (`server.shutdown=graceful`); fast startup |
| **10. Dev/prod parity** | Testcontainers matches production DB/Redis/Kafka |
| **11. Logs** | Stdout JSON; collected by platform (ELK, Loki) |
| **12. Admin processes** | Flyway migrations; Spring Batch for one-off tasks |

## Evolutionary Architecture

### Fitness Functions
Automated checks that guard architectural characteristics:

| Characteristic | Fitness Function |
|---------------|-----------------|
| Modularity | ArchUnit: no cyclic dependencies between packages |
| Performance | Load test: p99 < 500ms under expected load |
| Security | OWASP Dependency-Check: zero HIGH+ CVEs |
| Testability | JaCoCo: line coverage ≥80% |
| Coupling | ArchUnit: layers only depend downward |
| API compatibility | Contract tests pass against previous version |

### Implementing Fitness Functions
```java
@AnalyzeClasses(packages = "com.example")
class ArchitectureFitnessTest {
    @ArchTest
    static final ArchRule no_cycles = slices()
        .matching("com.example.(*)..")
        .should().beFreeOfCycles();

    @ArchTest
    static final ArchRule controllers_dont_access_repositories = noClasses()
        .that().resideInAPackage("..web..")
        .should().dependOnClassesThat().resideInAPackage("..repository..");
}
```

## Conway's Law

> "Organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations."

### Practical Implications
- Align service boundaries with team boundaries
- If one team owns orders and payments, a modular monolith is fine
- If separate teams own each, microservices reduce coordination overhead
- Inverse Conway maneuver: structure teams to produce the desired architecture

## Principle of Least Knowledge (Law of Demeter)

At the architecture level:
- Services communicate through well-defined APIs, not shared databases
- No service reads another service's database directly
- Events for cross-service communication; commands for requests
- API Gateway shields internal topology from external clients

## Separation of Deployment from Release

| Concept | Meaning |
|---------|---------|
| **Deployment** | New code running in production (but not necessarily serving traffic) |
| **Release** | Feature available to users |

Enable this with:
- **Feature flags**: Deploy code, enable feature progressively
- **Blue-green deployment**: Two environments; switch traffic after validation
- **Canary releases**: Route small % of traffic to new version
- **Spring profiles**: `@Profile("feature-x")` for configuration-based toggles

## Architecture Decision Framework

For every significant decision, evaluate:

1. **Context**: What constraints and forces apply?
2. **Options**: What are the alternatives? (at least 2)
3. **Trade-offs**: What do you gain and lose with each option?
4. **Decision**: What did you choose and why?
5. **Consequences**: What follow-up work is needed?
6. **Revisit trigger**: When should this decision be re-evaluated?

Document in an ADR -- see `references/adr-template.md`.
