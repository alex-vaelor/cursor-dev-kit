---
name: spring-jpa-patterns
description: "Use when working with JPA/Hibernate in Spring applications -- including entity design, relationship mapping, N+1 prevention, lazy loading, specifications, projections, transaction management, auditing, second-level cache, batch processing, Hibernate Envers, inheritance mapping, and embeddable patterns."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: data-access
  triggers: JPA, Hibernate, entity, N+1, LazyInitializationException, @Entity, @OneToMany, @ManyToOne, EntityGraph, JPQL, Spring Data JPA, @Transactional, specification, second-level cache, L2 cache, batch insert, Envers, @Audited, @Embeddable, inheritance mapping, AttributeConverter
  role: specialist
  scope: spring-jpa
  original-author: Juan Antonio Breña Moral
  related-skills: spring-data-access, spring-boot-core, database-design
---

# Spring JPA Patterns

Work with JPA/Hibernate in Spring applications using modern entity design, optimized queries, and proper transaction management.

## When to Use This Skill

- Design JPA entities and relationships
- Fix N+1 query problems
- Resolve `LazyInitializationException`
- Implement specifications for dynamic queries
- Configure auditing (`@CreatedDate`, `@CreatedBy`, Hibernate Envers)
- Optimize query performance with projections and entity graphs
- Manage transactions across service boundaries
- Configure Hibernate second-level cache
- Implement batch processing with Hibernate
- Design embeddables, inheritance hierarchies, and custom converters
- Audit entity history with Hibernate Envers

## Key Patterns

### Entity Design
- Use Lombok `@Getter`/`@Setter` (never `@Data`) on JPA entities
- Implement `equals`/`hashCode` on business key (not `@Id` alone)
- Helper methods for bidirectional relationships
- `@Version` for optimistic locking
- Default to `FetchType.LAZY` on all associations

### N+1 Prevention
- `JOIN FETCH` in JPQL queries
- `@EntityGraph` for declarative fetching
- `@BatchSize` for batch fetching
- Enable SQL logging in tests to detect N+1

### Transaction Management
- `@Transactional(readOnly = true)` at class level for read-heavy services
- `@Transactional` on individual write methods
- `Propagation.REQUIRES_NEW` for audit logs that must survive rollback
- `noRollbackFor` for non-critical side effects

### Specifications & Projections
- `JpaSpecificationExecutor` for dynamic query composition
- Interface-based projections for read-only views
- Record DTOs for type-safe projections

### Advanced Entity Mapping
- `@Embeddable`/`@Embedded` for value objects
- Inheritance strategies (SINGLE_TABLE, JOINED, @MappedSuperclass)
- `@AttributeConverter` for custom type conversions
- Composite keys with `@EmbeddedId`

### Hibernate Performance
- Second-level cache (L2) for reference data and read-heavy entities
- Batch processing with `hibernate.jdbc.batch_size` and `StatelessSession`
- Query hints for read-only and fetch size optimization
- Hibernate statistics for monitoring

### Hibernate Envers
- `@Audited` for entity change history tracking
- Revision queries and point-in-time entity reconstruction
- Spring Data Envers `RevisionRepository` integration

## Constraints

- **MANDATORY**: Run `./mvnw compile` before and after entity changes
- **VERIFY**: Run `./mvnw clean verify` after changes
- **NEVER** use `@Data` on JPA entities
- **ALWAYS** default to `FetchType.LAZY`

## References

| Topic | File | When to Load |
|-------|------|--------------|
| JPA guidelines and patterns | `references/jpa-guidelines.md` | When designing entities or repositories |
| JPA troubleshooting | `references/jpa-troubleshooting.md` | When fixing N+1, lazy loading, or performance issues |
| Validation patterns | `references/validation-patterns.md` | When implementing entity/DTO/cross-field validation |
| Hibernate performance | `references/hibernate-performance.md` | When configuring L2 cache, batch processing, or statistics |
| Advanced entity mapping | `references/entity-mapping-advanced.md` | When designing embeddables, inheritance, or converters |
| Hibernate Envers | `references/hibernate-envers.md` | When implementing entity audit history |

## Related Rules

- `rules/spring/jpa-hibernate.mdc` -- JPA/Hibernate conventions
- `rules/spring/data-access.mdc` -- data access conventions
- `rules/sql/query-optimization.mdc` -- SQL query optimization
- `rules/java/lombok.mdc` -- Lombok on entities

## Related Skills

- `skills/spring-data-access/` -- Spring Data JDBC patterns
- `skills/database-design/` -- schema design
