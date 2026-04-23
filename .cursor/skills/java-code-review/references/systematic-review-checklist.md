# Systematic Code Review Checklist for Java

## Pre-Review

- [ ] Read the PR description and linked issue/ticket
- [ ] Understand the intent: what problem does this solve?
- [ ] Check PR size: if >400 lines, suggest splitting

## 1. Design & Architecture

- [ ] Does the change follow existing project patterns?
- [ ] Are new abstractions justified and well-placed?
- [ ] Correct layer for the logic (controller vs service vs repository)?
- [ ] No circular dependencies introduced?
- [ ] Domain model changes follow DDD conventions (if applicable)?
- [ ] Spring bean scope appropriate (`@Scope`, prototype vs singleton)?

## 2. Naming & Conventions

- [ ] Class names: `PascalCase`, nouns (`OrderService`, `PaymentResult`)
- [ ] Method names: `camelCase`, verbs (`createOrder`, `findByEmail`)
- [ ] Constants: `UPPER_SNAKE_CASE`
- [ ] Package names: lowercase, no underscores
- [ ] No abbreviations except well-known ones (`id`, `dto`, `url`)
- [ ] Boolean methods/variables: `is*`, `has*`, `can*`, `should*`

## 3. Modern Java Usage (17/21)

- [ ] Records used for DTOs and value objects (instead of POJO + getters/setters)?
- [ ] Sealed interfaces for known type hierarchies?
- [ ] Pattern matching in `instanceof` checks?
- [ ] Switch expressions (with arrow syntax) instead of switch statements?
- [ ] Text blocks for multi-line strings?
- [ ] `var` used appropriately (local variables with obvious types)?
- [ ] Virtual threads considered for blocking I/O (Java 21)?
- [ ] No deprecated APIs used (`Date`, `Vector`, `Hashtable`, etc.)?

## 4. Null Safety

- [ ] No raw `null` returns from public methods — use `Optional<T>` for optional results
- [ ] JSpecify `@NullMarked` / `@Nullable` annotations present?
- [ ] Null checks at system boundaries (API inputs, external data)?
- [ ] No `Optional` used as method parameter or field?

## 5. Exception Handling

- [ ] Specific exception types (not bare `Exception` or `Throwable`)?
- [ ] Try-with-resources for closeable resources?
- [ ] No swallowed exceptions (empty catch blocks)?
- [ ] Exception messages include context (what failed and why)?
- [ ] `@ExceptionHandler` or `ProblemDetail` for REST API errors?
- [ ] Custom exceptions extend appropriate base class?

## 6. Concurrency & Thread Safety

- [ ] Shared mutable state properly synchronized?
- [ ] Immutable objects preferred (records, `List.of()`, `Map.of()`)?
- [ ] `CompletableFuture` used correctly (no blocking in async chains)?
- [ ] Virtual thread compatibility (no pinning: no `synchronized` around blocking calls)?
- [ ] Thread-safe collections used where needed (`ConcurrentHashMap`)?

## 7. Security

- [ ] Input validated at API boundary (`@Valid`, `@Size`, `@Pattern`)?
- [ ] No SQL injection (parameterized queries or Spring Data)?
- [ ] No secrets in code (passwords, API keys, tokens)?
- [ ] Authentication and authorization checked for new endpoints?
- [ ] Sensitive data not logged (passwords, tokens, PII)?
- [ ] CSRF protection in place for state-changing endpoints?
- [ ] Rate limiting for public-facing endpoints?

## 8. Performance

- [ ] No N+1 query patterns (use `JOIN FETCH` or `@EntityGraph`)?
- [ ] No unnecessary object creation in loops?
- [ ] String concatenation in loops uses `StringBuilder`?
- [ ] Database queries have appropriate indices?
- [ ] Pagination used for potentially large result sets?
- [ ] Caching considered for expensive, repeatable operations?

## 9. Testing

- [ ] New code has corresponding tests?
- [ ] Tests follow Given-When-Then / Arrange-Act-Assert structure?
- [ ] Test method names describe the scenario (`shouldReturnNotFoundWhenOrderMissing`)?
- [ ] No test anti-patterns (logic in tests, multiple assertions per test without clear sections)?
- [ ] Integration tests use `@SpringBootTest` with appropriate slices?
- [ ] Mocks used appropriately (not over-mocking)?
- [ ] Edge cases covered (null, empty, boundary values)?

## 10. Dependencies & Configuration

- [ ] No new dependencies without justification?
- [ ] Dependencies use Spring Boot BOM versions (no explicit version override without reason)?
- [ ] Configuration externalized (no hardcoded URLs, ports, credentials)?
- [ ] Feature flags for risky changes?

## 11. Documentation

- [ ] Public API methods have Javadoc?
- [ ] Non-obvious logic has inline comments explaining "why"?
- [ ] README updated if public behavior changed?
- [ ] ADR created for architectural decisions?

## Post-Review

- [ ] At least one positive observation noted
- [ ] All feedback tagged with severity: `[CRITICAL]`, `[MAJOR]`, `[MINOR]`, `[NIT]`
- [ ] Verdict clearly stated: Approve / Request Changes / Comment
