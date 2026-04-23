---
name: spring-graphql
description: "Use when building GraphQL APIs with Spring for GraphQL -- including schema design, controller mappings (@QueryMapping, @MutationMapping), DataLoader/BatchMapping for N+1 prevention, subscriptions, security, error handling, and testing with GraphQlTester."
risk: safe
source: new
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: api
  triggers: GraphQL, graphql, @QueryMapping, @MutationMapping, @SchemaMapping, @BatchMapping, DataLoader, GraphQlTester, schema.graphqls
  role: specialist
  scope: spring-graphql
  related-skills: spring-boot-core, spring-boot-rest, api-design
---

# Spring for GraphQL

Build GraphQL APIs using Spring for GraphQL with schema-first design.

## When to Use This Skill

- Build a GraphQL API with Spring Boot
- Design GraphQL schemas (types, queries, mutations, subscriptions)
- Implement data fetchers with `@QueryMapping` and `@MutationMapping`
- Prevent N+1 queries with `@BatchMapping` and `DataLoader`
- Secure GraphQL endpoints with Spring Security
- Test GraphQL controllers with `GraphQlTester`

## When to Use GraphQL vs REST

| Choose GraphQL | Choose REST |
|---------------|-------------|
| Clients have varying data needs (mobile vs web) | Fixed, well-known contracts |
| Deep nested relationships in single query | Simple CRUD operations |
| Rapid frontend iteration without backend changes | Strong HTTP caching needs |
| API aggregation layer | File upload/download |

## Constraints

- **MANDATORY**: Schema-first design (`*.graphqls` files in `src/main/resources/graphql/`)
- **ALWAYS** use `@BatchMapping` for relationship fields (N+1 prevention)
- **NEVER** expose GraphiQL or schema introspection in production
- **VERIFY**: Run `./mvnw clean verify` after changes

## References

| Topic | File | When to Load |
|-------|------|--------------|
| GraphQL implementation guide | `references/graphql-implementation.md` | Implementing GraphQL API |

## Related Rules

- `rules/spring/graphql.mdc` -- GraphQL conventions
- `rules/spring/rest-api.mdc` -- REST comparison
- `rules/security/api-security.mdc` -- API security

## Related Skills

- `skills/spring-boot-core/` -- Spring Boot fundamentals
- `skills/api-design/` -- API design principles
