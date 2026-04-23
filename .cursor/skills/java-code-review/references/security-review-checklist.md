# Security Review Checklist for Java Code

## Purpose

Systematic security-focused review checklist for Java/Spring Boot pull requests. Based on OWASP Top 10 and CWE Top 25.

## Pre-Review: Scope Assessment

- [ ] Does this PR touch authentication/authorization code?
- [ ] Does this PR handle user input (API params, form data, file uploads)?
- [ ] Does this PR interact with a database (queries, migrations)?
- [ ] Does this PR deal with secrets, keys, or tokens?
- [ ] Does this PR handle file operations or process execution?
- [ ] Does this PR modify security configuration (`SecurityFilterChain`, CORS, CSP)?

## 1. Injection Prevention (OWASP A03)

### SQL Injection
- [ ] No string concatenation in SQL queries
- [ ] All database access uses Spring Data JPA or parameterized `JdbcClient`
- [ ] Native queries use named parameters (`:paramName`), never concatenation
- [ ] Dynamic filtering uses Specifications or Criteria API

```java
// VULNERABLE
@Query(value = "SELECT * FROM users WHERE name = '" + name + "'", nativeQuery = true)

// SAFE
@Query("SELECT u FROM User u WHERE u.name = :name")
List<User> findByName(@Param("name") String name);

// SAFE: JdbcClient
jdbcClient.sql("SELECT * FROM users WHERE name = :name")
    .param("name", name)
    .query(User.class)
    .list();
```

### Command Injection
- [ ] No `Runtime.exec()` or `ProcessBuilder` with user-controlled input
- [ ] If external commands are required, use allowlists for permitted commands

### LDAP / XPath / Template Injection
- [ ] No user input in LDAP queries, XPath expressions, or template engines without escaping

## 2. Broken Authentication (OWASP A07)

- [ ] Passwords hashed with BCrypt, SCrypt, or Argon2 (never MD5/SHA-1)
- [ ] JWT tokens validated (signature, expiration, issuer, audience)
- [ ] Session configuration: secure, httpOnly, sameSite cookies
- [ ] Rate limiting on authentication endpoints
- [ ] No credentials in logs, error messages, or API responses

## 3. Sensitive Data Exposure (OWASP A02)

- [ ] No secrets hardcoded in source code (API keys, passwords, tokens)
- [ ] Sensitive data masked in logs (`password=***`, PII redacted)
- [ ] HTTPS enforced for all API endpoints
- [ ] Sensitive fields excluded from `toString()` and serialization
- [ ] Error responses don't expose internal details (stack traces, DB schema)

```java
// BAD: exposes internals
@ExceptionHandler(Exception.class)
public ResponseEntity<String> handle(Exception ex) {
    return ResponseEntity.status(500).body(ex.getMessage());
}

// GOOD: RFC 9457 ProblemDetail without internals
@ExceptionHandler(Exception.class)
public ProblemDetail handle(Exception ex) {
    log.error("Unhandled exception", ex);
    return ProblemDetail.forStatusAndDetail(
        HttpStatus.INTERNAL_SERVER_ERROR, "An unexpected error occurred");
}
```

## 4. Access Control (OWASP A01)

- [ ] All endpoints have explicit authorization (`@PreAuthorize`, `SecurityFilterChain` rules)
- [ ] No `permitAll()` on sensitive endpoints
- [ ] Resource ownership validated (user can only access their own data)
- [ ] Admin endpoints protected and audited
- [ ] Method-level security for service operations where needed

```java
// Verify resource ownership, not just authentication
@GetMapping("/orders/{id}")
@PreAuthorize("hasRole('USER')")
public OrderResponse getOrder(@PathVariable Long id) {
    var order = orderService.findById(id);
    if (!order.userId().equals(currentUser.getId())) {
        throw new AccessDeniedException("Not your order");
    }
    return OrderResponse.from(order);
}
```

## 5. Security Misconfiguration (OWASP A05)

- [ ] CORS configured for specific origins (not `*` in production)
- [ ] CSRF protection enabled for browser-facing endpoints
- [ ] Security headers set (CSP, X-Frame-Options, X-Content-Type-Options)
- [ ] Actuator endpoints secured (`/actuator/**` not publicly accessible)
- [ ] Debug mode disabled in production
- [ ] Default Spring Security settings reviewed and tightened

## 6. Vulnerable Dependencies (OWASP A06)

- [ ] No new dependencies with known CVEs
- [ ] Dependencies from trusted sources (Maven Central)
- [ ] OWASP Dependency-Check integrated in CI
- [ ] Spring Boot BOM used for consistent, patched versions

## 7. Input Validation (CWE-20)

- [ ] All API inputs validated with `@Valid` and Jakarta Bean Validation
- [ ] String inputs have `@Size` limits
- [ ] Numeric inputs have `@Min`/`@Max` bounds
- [ ] File uploads validated (size, type, content)
- [ ] Path parameters validated (no path traversal: `../`)

```java
public record CreateOrderRequest(
    @NotNull @Size(min = 1, max = 100) List<@Valid OrderItem> items,
    @NotNull @Valid ShippingAddress shippingAddress,
    @NotNull @Positive BigDecimal total
) {}
```

## 8. Logging & Monitoring Security

- [ ] Security events logged (login success/failure, access denied, privilege changes)
- [ ] Log injection prevented (no unescaped user input in log messages)
- [ ] Correlation IDs used for tracing across services
- [ ] Alerting configured for anomalous patterns (brute force, privilege escalation)

## 9. Cryptography (OWASP A02)

- [ ] TLS 1.2+ for all external communication
- [ ] No custom cryptography implementations
- [ ] Secure random number generation (`SecureRandom`, not `Random`)
- [ ] Encryption keys managed via vault or KMS, not in code

## 10. Deserialization (OWASP A08)

- [ ] Jackson configured to reject unknown properties
- [ ] No `ObjectInputStream.readObject()` with untrusted input
- [ ] JSON deserialization has explicit type definitions (no polymorphic deserialization without safeguards)

## Review Output

For security findings, use this format:
```
[CRITICAL-SECURITY] SQL Injection in OrderRepository.findByFilter()
Location: src/main/java/.../OrderRepository.java:45
Issue: User input concatenated into native query
Fix: Use @Param with named parameters or Specification API
CWE: CWE-89 (SQL Injection)
OWASP: A03:2021 Injection
```
