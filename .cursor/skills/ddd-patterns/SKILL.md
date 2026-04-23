---
name: ddd-patterns
description: "Use when applying Domain-Driven Design -- including strategic design (bounded contexts, context mapping, subdomain classification), tactical patterns (aggregates, entities, value objects, domain events, repositories), and ubiquitous language definition."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: architecture
  triggers: DDD, domain-driven design, bounded context, aggregate, value object, domain event, context mapping, ubiquitous language, subdomain, anti-corruption layer
  role: specialist
  scope: ddd
  related-skills: architecture-design, spring-boot-core, spring-jpa-patterns
---

# DDD Patterns

Apply Domain-Driven Design strategic and tactical patterns for complex business domains.

## When to Use This Skill

- Define bounded contexts and subdomain classification
- Map relationships between contexts (context mapping)
- Design aggregates, entities, and value objects
- Establish ubiquitous language with domain experts
- Refactor anemic domain models into behavior-rich objects
- Define domain event boundaries

## Strategic Design

- **Subdomain classification**: Core (competitive advantage), Supporting (necessary), Generic (commodity)
- **Bounded contexts**: Own data, language, and model per context
- **Context mapping**: Shared Kernel, Customer-Supplier, Conformist, Anti-Corruption Layer, Open Host Service

## Tactical Patterns

- **Aggregates**: Entry point for data access, enforce invariants, reference by ID
- **Entities**: Identity-based, mutable, `equals`/`hashCode` on business key
- **Value objects**: Immutable, attribute-based (Java records), validate in constructor
- **Domain events**: Past tense naming, immutable records, published via Spring events
- **Domain services**: Stateless operations that span entities
- **Repositories**: One per aggregate root, interface in domain, implementation in infrastructure

## Constraints

- Domain layer must have zero framework dependencies
- Keep aggregates small; prefer smaller consistency boundaries
- Reference other aggregates by ID, not direct object reference
- Emit domain events for cross-aggregate coordination

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Strategic design templates | `references/strategic-design-template.md` | Defining contexts and subdomains |
| Context mapping patterns | `references/context-map-patterns.md` | Designing integrations between contexts |
| Tactical patterns checklist | `references/tactical-checklist.md` | Implementing aggregates, entities, events |

## Related Rules

- `rules/architecture/ddd.mdc` -- DDD conventions
- `rules/architecture/design-patterns.mdc` -- architecture patterns

## Related Skills

- `skills/architecture-design/` -- system architecture
- `skills/spring-jpa-patterns/` -- JPA entity patterns for DDD
