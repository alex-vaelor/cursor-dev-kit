# Java Code Review Checklist

Structured checklist for reviewing Java pull requests. Use this as a systematic walkthrough.

## 1. Build and Compilation

- [ ] Code compiles without warnings (`./mvnw compile`)
- [ ] All tests pass (`./mvnw clean verify`)
- [ ] No new compiler warnings introduced
- [ ] Dependencies are justified and version-pinned

## 2. Naming and Formatting

- [ ] Package names follow reverse-domain convention
- [ ] Class names are PascalCase and descriptive (no `Impl` suffix without reason)
- [ ] Method names are camelCase, verb-based
- [ ] Constants are UPPER_SNAKE_CASE
- [ ] No wildcard imports
- [ ] Import ordering: `java.*`, `jakarta.*`, third-party, project
- [ ] Line length <= 120 characters
- [ ] Consistent indentation (4 spaces)

## 3. Class Design

- [ ] Single Responsibility: class has one reason to change
- [ ] Favors composition over inheritance
- [ ] Uses interfaces for contracts
- [ ] Immutable where possible (records, final fields)
- [ ] Access modifiers are as restrictive as possible
- [ ] No God classes (> 500 lines warrants inspection)

## 4. Modern Java Features

- [ ] Records used for immutable data carriers
- [ ] Sealed classes for closed type hierarchies
- [ ] Pattern matching for instanceof and switch where applicable
- [ ] Switch expressions with arrow syntax
- [ ] Text blocks for multi-line strings
- [ ] `var` only where type is obvious

## 5. Null Safety

- [ ] JSpecify `@NullMarked` at package level
- [ ] `@Nullable` on specific nullable returns/parameters
- [ ] `Objects.requireNonNull` at public boundaries
- [ ] `Optional` for return types, never for fields or parameters
- [ ] Empty collections returned instead of null

## 6. Exception Handling

- [ ] Specific exception types (not generic `Exception`)
- [ ] Try-with-resources for all `AutoCloseable`
- [ ] Exception chaining preserves context
- [ ] No silently swallowed exceptions
- [ ] No log-and-throw duplication
- [ ] `InterruptedException` handled correctly

## 7. Dependency Injection

- [ ] Constructor injection only (no `@Autowired` on fields)
- [ ] Dependencies are `final`
- [ ] Single constructor per bean
- [ ] `@Qualifier` / `@Primary` for disambiguation

## 8. Testing

- [ ] New behavior has corresponding tests
- [ ] Given-When-Then structure
- [ ] Descriptive test names
- [ ] AssertJ assertions (not JUnit assertions)
- [ ] No shared mutable state between tests
- [ ] Integration tests use Testcontainers (not H2/in-memory DB)
- [ ] Edge cases and error paths tested

## 9. Security

- [ ] Input validated at boundaries
- [ ] SQL uses parameterized queries
- [ ] No secrets hardcoded
- [ ] No sensitive data in logs or error responses
- [ ] Authentication/authorization checked on new endpoints

## 10. Performance

- [ ] No N+1 query patterns
- [ ] No unnecessary object creation in loops
- [ ] Appropriate data structures used
- [ ] Pagination for large result sets
- [ ] No blocking calls in virtual thread / reactive contexts

## 11. Concurrency

- [ ] Thread-safe if accessed by multiple threads
- [ ] No `synchronized` around blocking I/O (virtual thread pinning)
- [ ] Proper use of `ConcurrentHashMap`, `AtomicInteger`, etc.
- [ ] `CompletableFuture` has timeouts

## 12. Spring-Specific

- [ ] Correct stereotype annotations (`@RestController`, `@Service`, `@Repository`)
- [ ] `@Transactional` on service methods, not repositories
- [ ] `@ConfigurationProperties` with `@Validated`
- [ ] Controller methods return `ResponseEntity` with appropriate status codes
- [ ] Error handling via `@ControllerAdvice`
