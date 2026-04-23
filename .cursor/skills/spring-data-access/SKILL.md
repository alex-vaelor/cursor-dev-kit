---
name: spring-data-access
description: "Use when implementing or reviewing data access with Spring -- including Spring JDBC (JdbcClient), Spring Data JDBC, repository design, aggregate roots, Flyway migrations, transactions, and query patterns."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: repository, JDBC, Spring Data, JdbcClient, Flyway, migration, database, SQL, transaction, aggregate
  role: specialist
  scope: spring-data-access
  original-author: Juan Antonio Breña Moral
  related-skills: spring-boot-core, spring-boot-testing
---

# Spring Data Access

Implement and review data access patterns with Spring JDBC, Spring Data JDBC, and Flyway. Aligned with Spring Boot 4.0.x.

## When to Use This Skill

- Implement repository layer with Spring Data JDBC
- Write SQL queries with Spring JDBC / JdbcClient
- Design aggregate-root-based persistence
- Set up Flyway database migrations
- Review transaction management patterns

## Coverage

### Spring JDBC
- `JdbcClient` for programmatic SQL (Spring Framework 7.x)
- Named parameters, `RowMapper` implementations
- Batch operations and stored procedures

### Spring Data JDBC
- Aggregate-root design: one repository per aggregate
- `CrudRepository` / `ListCrudRepository` interfaces
- Custom queries with `@Query` annotation
- Projections for read-only views

### Flyway Migrations
- Versioned migration naming: `V{n}__{description}.sql`
- Migration rules: never modify applied migrations
- Testing migrations with Testcontainers

### Transactions
- `@Transactional` on service methods
- Read-only transactions for queries
- Keeping transactions short

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Spring JDBC guidelines | `references/spring-jdbc.md` | When working with JdbcClient |
| Spring Data JDBC guidelines | `references/spring-data-jdbc.md` | When working with repositories |
| Flyway migration guidelines | `references/flyway-migrations.md` | When managing schema migrations |

## Related Rules

- `rules/spring/data-access.mdc` -- data access rules
- `rules/spring/migrations.mdc` -- migration conventions
