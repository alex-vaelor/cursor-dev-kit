---
name: saga-patterns
description: "Use when implementing distributed transactions across services -- including saga choreography vs orchestration, compensation logic, idempotency, state machines, and failure recovery in Java/Spring Boot applications."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: architecture
  triggers: saga, distributed transaction, compensation, choreography, orchestration, state machine, idempotency, eventual consistency, cross-service transaction
  role: specialist
  scope: distributed-patterns
  related-skills: architecture-design, ddd-patterns, spring-boot-core
---

# Saga Patterns

Implement distributed transactions using saga patterns for Java/Spring Boot applications.

## When to Use This Skill

- Implement transactions spanning multiple services or bounded contexts
- Choose between choreography and orchestration patterns
- Design compensation logic for failure recovery
- Ensure idempotency for distributed operations
- Implement state machines for saga coordination

## When NOT to Use Sagas

- Single-service transactions: use `@Transactional`
- Simple request-response: no distributed state needed
- Read-only operations: no consistency concern

## Pattern Selection

| Factor | Choreography | Orchestration |
|--------|-------------|---------------|
| **Coordination** | Each service reacts to events | Central coordinator manages flow |
| **Coupling** | Low (event-driven) | Medium (orchestrator knows steps) |
| **Visibility** | Harder to trace full flow | Clear flow in one place |
| **Complexity at scale** | Grows with # of participants | Contained in orchestrator |
| **Best for** | 2-4 services, simple flows | 5+ services, complex flows |
| **Spring tool** | `ApplicationEventPublisher`, Kafka | Spring State Machine, Temporal |

## Constraints

- Every saga step MUST have a compensation action
- All operations MUST be idempotent (safe to retry)
- Use correlation IDs to track saga instances across services
- Set timeouts for each step; define timeout compensation
- Log all state transitions for debugging
- Test failure at every step (chaos testing)

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Saga implementation guide | `references/saga-implementation.md` | Implementing saga patterns |

## Related Rules

- `rules/architecture/microservices.mdc` -- microservices patterns
- `rules/architecture/design-patterns.mdc` -- architectural patterns

## Related Skills

- `skills/architecture-design/` -- pattern selection
- `skills/ddd-patterns/` -- bounded contexts and domain events
- `skills/spring-boot-core/` -- Spring Boot fundamentals
