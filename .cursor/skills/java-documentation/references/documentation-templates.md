# Documentation Templates for Java Projects

## README Template

```markdown
# [Project Name]

[One-paragraph description of what this project does and who it's for.]

## Prerequisites

- Java 21+ (via [SDKMAN!](https://sdkman.io/) or manual install)
- Maven 3.9+ (Maven wrapper included: `./mvnw`)
- Docker & Docker Compose (for integration tests and local dependencies)

## Quick Start

```bash
# Clone and build
git clone https://github.com/org/project.git
cd project
./mvnw clean verify

# Run locally
./mvnw spring-boot:run
# App available at http://localhost:8080
```

## Project Structure

```
src/
├── main/java/com/example/app/
│   ├── web/           # REST controllers
│   ├── service/       # Business logic
│   ├── repository/    # Data access
│   └── domain/        # Entities and value objects
├── main/resources/
│   ├── application.yml
│   └── db/migration/  # Flyway migrations
└── test/java/         # Tests mirror main structure
```

## Configuration

| Property | Default | Description |
|----------|---------|-------------|
| `server.port` | 8080 | HTTP port |
| `spring.datasource.url` | `jdbc:postgresql://localhost:5432/app` | Database URL |

## API Documentation

- OpenAPI spec: http://localhost:8080/v3/api-docs
- Swagger UI: http://localhost:8080/swagger-ui.html

## Testing

```bash
./mvnw test              # Unit tests
./mvnw verify            # Unit + integration tests
./mvnw jacoco:report     # Coverage report at target/site/jacoco/
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[License type] -- see [LICENSE](LICENSE).
```

## ADR Template

```markdown
# ADR-NNN: [Decision Title]

**Date**: YYYY-MM-DD
**Status**: Proposed | Accepted | Superseded by ADR-XXX | Deprecated

## Context

[Describe the situation, the problem, the constraints, and the forces at play.]

## Decision

[State the decision clearly. Use active voice: "We will use X for Y."]

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Trade-off 1]
- [Trade-off 2]

### Risks
- [Risk and mitigation]

## Alternatives Considered

| Alternative | Pros | Cons | Why Not |
|-------------|------|------|---------|
| [Option A] | ... | ... | ... |
| [Option B] | ... | ... | ... |
```

## CHANGELOG Template (Keep a Changelog)

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New feature description

### Changed
- Existing behavior change

### Fixed
- Bug fix description

### Removed
- Removed feature

## [1.0.0] - YYYY-MM-DD

### Added
- Initial release with core order management
- REST API for CRUD operations
- PostgreSQL persistence with Flyway migrations
- JWT authentication via Spring Security
- OpenAPI documentation
```

## CONTRIBUTING Template

```markdown
# Contributing to [Project Name]

## Development Setup

1. Install Java 21+ via SDKMAN!: `sdk install java 21-tem`
2. Clone: `git clone [repo-url]`
3. Build: `./mvnw clean verify`
4. Run: `./mvnw spring-boot:run`

## Code Standards

- Follow `shared/java-conventions.md`
- All public APIs must have Javadoc
- Tests required for all new functionality
- Quality gates must pass: Checkstyle, SpotBugs, JaCoCo ≥80%

## Workflow

1. Create a feature branch from `main`: `git checkout -b feat/description`
2. Make changes with clear, focused commits
3. Run full verification: `./mvnw clean verify`
4. Create a pull request with description following the PR template
5. Address review feedback
6. Squash and merge after approval

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(orders): add bulk order creation endpoint
fix(auth): validate JWT audience claim
docs(readme): update deployment instructions
refactor(payment): extract PaymentGateway interface
test(orders): add integration test for order cancellation
```
```

## Javadoc Class Template

```java
/**
 * Manages order lifecycle including creation, fulfillment, and cancellation.
 *
 * <p>This service orchestrates order processing by coordinating with
 * {@link InventoryService} for stock reservation and {@link PaymentService}
 * for payment processing. All operations are transactional.
 *
 * <h2>Thread Safety</h2>
 * <p>This class is thread-safe. All mutable state is managed by the
 * underlying database with optimistic locking.
 *
 * <h2>Usage Example</h2>
 * <pre>{@code
 * var request = new CreateOrderRequest(items, shippingAddress);
 * Order order = orderService.createOrder(request);
 * }</pre>
 *
 * @see InventoryService
 * @see PaymentService
 * @since 1.0.0
 */
@Service
public class OrderService {
    // ...
}
```

## API Endpoint Javadoc Template

```java
/**
 * Creates a new order for the authenticated user.
 *
 * <p>Validates the request, reserves inventory, and persists the order.
 * Returns the created order with a {@code 201 Created} status and
 * {@code Location} header pointing to the new resource.
 *
 * @param request the order creation request containing items and shipping address
 * @return the created order response with HTTP 201 status
 * @throws OrderValidationException if the request fails business validation
 * @throws InsufficientStockException if any item is out of stock
 */
@PostMapping
public ResponseEntity<OrderResponse> createOrder(@Valid @RequestBody CreateOrderRequest request) {
    // ...
}
```
