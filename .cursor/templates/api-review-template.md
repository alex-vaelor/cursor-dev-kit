# API Design Review: [API Name]

## Date
[YYYY-MM-DD]

## Reviewer
[Name]

## API Summary

| Property | Value |
|----------|-------|
| API Name | [e.g., Order Management API] |
| Version | [e.g., v1] |
| Base URL | [e.g., /api/v1/orders] |
| Authentication | [e.g., JWT Bearer token] |
| Specification | [Link to openapi.yaml] |

## Review Checklist

### Resource Design
- [ ] URIs use plural nouns (`/orders`, not `/order`)
- [ ] No verbs in URIs (`/orders`, not `/getOrders`)
- [ ] Resource hierarchy reflects domain relationships
- [ ] Consistent naming conventions across all endpoints
- [ ] Sub-resources used appropriately (e.g., `/orders/{id}/items`)

### HTTP Methods
- [ ] GET for read-only operations
- [ ] POST for creation (returns 201 + Location header)
- [ ] PUT for full replacement
- [ ] PATCH for partial update
- [ ] DELETE for removal (returns 204)
- [ ] No side effects on GET requests

### Status Codes
- [ ] 200 OK for successful GET/PUT/PATCH
- [ ] 201 Created for successful POST (with Location header)
- [ ] 204 No Content for successful DELETE
- [ ] 400 Bad Request for validation errors
- [ ] 401 Unauthorized for missing/invalid authentication
- [ ] 403 Forbidden for insufficient permissions
- [ ] 404 Not Found for missing resources
- [ ] 409 Conflict for business rule violations
- [ ] 500 never returned intentionally

### Error Handling
- [ ] RFC 9457 Problem Details format for all errors
- [ ] No stack traces or internal details exposed
- [ ] Validation errors include field-level details
- [ ] Error messages are actionable for API consumers

### Request/Response Design
- [ ] Records used for DTOs (not domain entities)
- [ ] ISO-8601 timestamps (`Instant`)
- [ ] Consistent field naming (camelCase)
- [ ] No null fields in responses (use empty collections)
- [ ] Pagination for list endpoints (`page`, `size`, `sort`)

### Security
- [ ] Authentication required for all non-public endpoints
- [ ] Authorization checked at endpoint level
- [ ] CORS properly configured
- [ ] Rate limiting in place
- [ ] Input validation with Bean Validation annotations
- [ ] No sensitive data in URLs or logs

### Documentation
- [ ] OpenAPI specification exists and is up to date
- [ ] All endpoints documented with descriptions
- [ ] Request/response examples provided
- [ ] Error responses documented
- [ ] Authentication requirements documented

### Versioning
- [ ] Versioning strategy documented (URI path or header)
- [ ] Deprecation policy defined
- [ ] `Deprecation` and `Sunset` headers for deprecated endpoints

## Findings

### [CRITICAL]
[List critical findings that must be addressed]

### [MAJOR]
[List major findings that should be addressed]

### [MINOR]
[List minor findings and suggestions]

## Recommendations

[Summary of recommended changes with priority]

## Approval

- [ ] Approved for implementation
- [ ] Approved with conditions (list conditions)
- [ ] Not approved (requires rework)
