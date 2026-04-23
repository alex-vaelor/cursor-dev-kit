---
name: spring-boot-rest
description: "Use when designing, reviewing, or improving REST APIs with Spring Boot -- including HTTP methods, resource URIs, status codes, DTOs, versioning, pagination, Bean Validation, error handling, OpenAPI-first design, and Problem Details."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: REST, API, controller, endpoint, HTTP, OpenAPI, swagger, validation, error handling, problem details
  role: specialist
  scope: spring-boot-rest
  original-author: Juan Antonio Breña Moral
  related-skills: spring-boot-core, java-exception-handling
---

# Spring Boot REST API Design

Design and review REST APIs with Spring Boot using HTTP semantics, DTOs, validation, and API-first practices. Aligned with Spring Boot 4.0.x.

## When to Use This Skill

- Design new REST API endpoints
- Review existing REST API code
- Implement OpenAPI-first (contract-first) API development
- Set up error handling with Problem Details (RFC 9457)
- Implement pagination, versioning, and caching

## Coverage

- HTTP methods: GET, POST, PUT, PATCH, DELETE semantics
- Resource URIs and naming conventions
- HTTP status codes for each operation
- DTOs (records) for requests and responses
- API versioning and deprecation headers
- Bean Validation at the boundary
- Idempotency and safe retries
- ETag concurrency control
- HTTP caching semantics
- Error handling with RFC 9457 Problem Details
- Content negotiation (JSON, vendor media types)
- API-first with OpenAPI Generator (`useSpringBoot4` flag)

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full REST API guidelines | `references/rest-api-guidelines.md` | Before any REST API review |

## Related Rules

- `rules/spring/rest-api.mdc` -- REST API rules
