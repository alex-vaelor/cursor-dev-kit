---
name: java-exception-handling
description: "Use when applying Java exception handling best practices -- including specific exception types, try-with-resources, secure exception messages, exception chaining, fail-fast validation, thread interruption handling, logging policy, API boundary translation, retry/idempotency, timeouts, suppressed exceptions, and async/reactive error propagation."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: exception, error handling, try-with-resources, try-catch, throw, logging, retry, timeout, fail-fast
  role: specialist
  scope: java-error-handling
  original-author: Juan Antonio Breña Moral
  related-skills: java-oop-design, java-concurrency, java-observability
---

# Java Exception Handling

Apply comprehensive exception handling best practices for robust, secure, and debuggable Java code.

## When to Use This Skill

- Review exception handling patterns in Java code
- Implement proper resource management with try-with-resources
- Design custom exception hierarchies
- Apply fail-fast input validation
- Implement retry and timeout patterns
- Set up exception translation at API boundaries

## Coverage

- Specific exception types and custom exceptions
- Resource management with try-with-resources
- Fail-fast input validation
- Secure exception handling (no sensitive data leakage)
- Exception chaining and context preservation
- Thread interruption handling
- Logging policy: structured, de-duplicated
- API boundary translation with centralized handlers
- Retry with backoff for idempotent operations
- Timeouts, deadlines, and cancellation
- Suppressed exceptions for cleanup failures
- Async/reactive error propagation

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements
- **BEFORE APPLYING**: Read the reference for detailed examples and constraints

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full exception handling guidelines | `references/exception-handling-guidelines.md` | Before any exception handling review |
| Resilience patterns | `references/resilience-patterns.md` | When implementing circuit breakers, retries, bulkheads |

## Related Rules

- `rules/java/exception-handling.mdc` -- exception handling rules
- `rules/java/logging.mdc` -- logging conventions
