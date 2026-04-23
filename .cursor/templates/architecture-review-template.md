---
name: Architecture Review
about: Template for reviewing architectural decisions and designs in Java projects
---

## Review Subject

<!-- System, component, or feature being reviewed -->

## Context

<!-- Current state, constraints, business requirements driving the decision -->

## Architecture Overview

<!-- High-level description. Include diagrams if helpful. -->

## Design Decisions

### Decision 1: [Title]

| Aspect | Detail |
|--------|--------|
| **Options considered** | |
| **Chosen approach** | |
| **Rationale** | |
| **Trade-offs** | |
| **Risks** | |

## Review Checklist

### Structure
- [ ] Package organization follows domain-driven grouping
- [ ] Clear separation of concerns (controller -> service -> repository)
- [ ] No circular dependencies between packages
- [ ] Module boundaries are well-defined (for multi-module projects)

### Design
- [ ] SOLID principles followed
- [ ] Appropriate use of design patterns
- [ ] Composition preferred over inheritance
- [ ] Domain model is well-defined

### Data Access
- [ ] Repository-per-aggregate pattern
- [ ] Transaction boundaries are correct
- [ ] N+1 query patterns avoided
- [ ] Database migrations are versioned (Flyway)

### API Design
- [ ] RESTful resource naming
- [ ] Appropriate HTTP methods and status codes
- [ ] DTOs separate from domain entities
- [ ] Error handling uses Problem Details
- [ ] Pagination for list endpoints

### Security
- [ ] Authentication required on all non-public endpoints
- [ ] Authorization at method and resource level
- [ ] Input validation at boundaries
- [ ] No secrets in code or configuration files

### Scalability
- [ ] Stateless where possible
- [ ] Database queries are indexed
- [ ] Caching strategy defined (if applicable)
- [ ] Async processing for long-running operations

### Observability
- [ ] Structured logging with correlation IDs
- [ ] Health check endpoints
- [ ] Metrics exposed for key operations
- [ ] Error categorization supports monitoring

### Testing
- [ ] Testing strategy defined (unit, integration, acceptance)
- [ ] Critical paths have comprehensive test coverage
- [ ] Testcontainers for integration tests

## Recommendations

<!-- Ordered list of recommendations with priority (must/should/could) -->

## Open Questions

<!-- Questions for the author or team -->
