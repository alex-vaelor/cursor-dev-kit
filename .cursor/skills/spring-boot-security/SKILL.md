---
name: spring-boot-security
description: "Use when implementing or reviewing Spring Security -- including SecurityFilterChain configuration, JWT authentication, OAuth2 resource server, method security, CORS, CSRF, and security testing patterns for Spring Boot 4.x / Spring Security 7.x."
risk: critical
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: security
  triggers: spring security, authentication, authorization, JWT, OAuth2, SecurityFilterChain, CORS, CSRF, method security, @PreAuthorize
  role: specialist
  scope: spring-security
  original-author: Juan Antonio Breña Moral
  related-skills: spring-boot-core, spring-boot-rest
---

# Spring Boot Security

Implement and review Spring Security configurations for Spring Boot 4.x / Spring Security 7.x applications.

## When to Use This Skill

- Configure `SecurityFilterChain` for HTTP security
- Implement JWT-based authentication
- Set up OAuth2 resource server
- Apply method-level security (`@PreAuthorize`, `@Secured`)
- Configure CORS and CSRF policies
- Review security configuration for vulnerabilities
- Test secured endpoints

## Key Patterns

### SecurityFilterChain (Spring Security 7.x)
- Lambda DSL configuration (no `WebSecurityConfigurerAdapter`)
- `@EnableWebSecurity` + `@EnableMethodSecurity`
- Stateless session management for APIs
- Custom authentication filters

### JWT Authentication
- `OncePerRequestFilter` for token extraction and validation
- `JwtService` for token generation, validation, and claims extraction
- Refresh token rotation pattern
- BCrypt password encoding (strength 12+)

### OAuth2 Resource Server
- `oauth2ResourceServer()` with JWT decoder
- Custom `JwtAuthenticationConverter` for role mapping
- Issuer location validation

### Method Security
- `@PreAuthorize("hasRole('ADMIN')")` for role checks
- `@PreAuthorize("#userId == authentication.principal.id")` for ownership checks
- `@PostAuthorize` for return-value authorization

## Constraints

- **MANDATORY**: Run `./mvnw compile` before and after security changes
- **VERIFY**: Run `./mvnw clean verify` after changes
- **NEVER** store JWT secrets in source code -- use environment variables or vault
- **NEVER** disable CSRF without explicit justification (stateless APIs are acceptable)

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Security implementation patterns | `references/security-implementation.md` | When implementing SecurityFilterChain, JWT, OAuth2 |

## Related Rules

- `rules/spring/security.mdc` -- Spring Security conventions
- `rules/security/application-security.mdc` -- application security
- `rules/security/api-security.mdc` -- API security

## Related Skills

- `skills/spring-boot-core/` -- Spring Boot core conventions
- `skills/spring-boot-rest/` -- REST API patterns
