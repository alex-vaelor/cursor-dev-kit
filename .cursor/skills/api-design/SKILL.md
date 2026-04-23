---
name: api-design
description: "Use when designing REST APIs -- including OpenAPI specification, resource modeling, versioning strategy, error handling (RFC 9457), pagination, HATEOAS, and API review."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: api
  triggers: API design, REST API, OpenAPI, Swagger, API versioning, pagination, HATEOAS, RFC 9457, API review, resource modeling
  role: specialist
  scope: api
  related-skills: spring-boot-rest, spring-boot-core, architecture-design
---

# API Design

Design, document, and review REST APIs following OpenAPI specification and modern best practices.

## When to Use This Skill

- Design new REST API endpoints
- Write OpenAPI specifications
- Choose API versioning strategy
- Design error responses (RFC 9457 Problem Details)
- Implement pagination and filtering
- Review APIs for consistency and usability
- Generate code from OpenAPI specs

## Principles

- **Resource-oriented**: URIs represent resources (nouns, plural)
- **HTTP semantics**: Correct methods (GET=read, POST=create, PUT=replace, PATCH=update, DELETE=remove)
- **Stateless**: No server-side session; pass all context in request
- **Consistent**: Uniform naming, error format, pagination across all endpoints
- **Documented**: OpenAPI spec as the source of truth

## API-First Workflow

1. **Design**: Write `openapi.yaml` specification first
2. **Review**: API design review before implementation
3. **Generate**: Use OpenAPI Generator to create server interfaces
4. **Implement**: Implement generated interfaces in controllers
5. **Test**: Contract tests to validate spec compliance

## Error Handling (RFC 9457)

```json
{
  "type": "https://api.example.com/errors/validation",
  "title": "Validation Failed",
  "status": 400,
  "detail": "Email address is invalid",
  "instance": "/users/registration"
}
```

## Constraints

- API specification must be reviewed before implementation
- Use RFC 9457 Problem Details for all error responses
- Never expose internal implementation details in API responses
- Version APIs from day one (URI path or header)

## References

| Topic | File | When to Load |
|-------|------|--------------|
| REST API guidelines | `references/rest-api-guidelines.md` | Designing endpoints |
| OpenAPI conventions | `references/openapi-conventions.md` | Writing specifications |
| API authentication | `references/api-authentication.md` | Implementing JWT, OAuth2, API keys |
| Rate limiting | `references/rate-limiting.md` | Implementing rate limits with Bucket4j/Resilience4j |
| API response patterns | `references/api-response-patterns.md` | Designing responses, pagination, error handling |
| HATEOAS guide | `references/hateoas-guide.md` | Implementing hypermedia-driven APIs |

## Related Rules

- `rules/spring/rest-api.mdc` -- Spring REST conventions
- `rules/security/api-security.mdc` -- API security

## Related Skills

- `skills/spring-boot-rest/` -- Spring Boot REST implementation
- `skills/architecture-design/` -- system design
