---
name: database-design
description: "Use when designing database schemas -- including normalization, data type selection, indexing strategy, migration planning, query optimization, and database technology selection."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: data
  triggers: database design, schema, normalization, indexing, SQL optimization, migration, EXPLAIN ANALYZE, N+1, database selection, PostgreSQL
  role: specialist
  scope: database
  related-skills: spring-data-access, spring-jpa-patterns, api-design
---

# Database Design

Design relational database schemas with proper normalization, indexing, and migration strategy.

## When to Use This Skill

- Design new database schemas
- Choose between database technologies
- Plan indexing strategy for performance
- Optimize SQL queries (EXPLAIN ANALYZE)
- Design safe database migrations
- Fix N+1 query problems
- Review schema design for anti-patterns

## Workflow

1. **Requirements**: Gather data model requirements and access patterns
2. **Technology**: Select database technology for the context
3. **Schema**: Design normalized schema (3NF baseline)
4. **Indexes**: Plan indexes based on query patterns
5. **Migration**: Create versioned migration scripts
6. **Optimize**: Validate with EXPLAIN ANALYZE

## Constraints

- Every table must have a primary key
- Foreign keys for all relationships
- NOT NULL on columns that must always have a value
- Test migrations against production-like data
- Never modify already-applied migrations

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Schema design principles | `references/schema-design.md` | Designing tables and relationships |
| Indexing strategies | `references/indexing.md` | Planning indexes |
| Query optimization | `references/query-optimization.md` | Fixing slow queries |
| Migration patterns | `references/migrations.md` | Planning schema changes |
| Database selection | `references/database-selection.md` | Choosing technology |
| Multi-tenant patterns | `references/multi-tenant-patterns.md` | SaaS multi-tenancy design |

## Related Rules

- `rules/sql/database-design.mdc` -- schema design conventions
- `rules/sql/query-optimization.mdc` -- query performance
- `rules/sql/migrations.mdc` -- migration conventions

## Related Skills

- `skills/spring-data-access/` -- Spring Data access patterns
- `skills/spring-jpa-patterns/` -- JPA entity design
