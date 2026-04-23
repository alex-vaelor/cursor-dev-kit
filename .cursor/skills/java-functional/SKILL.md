---
name: java-functional
description: "Use when applying Java functional programming patterns -- including streams, lambdas, Optional, method references, functional interfaces, functional exception handling, composition, and data transformation pipelines."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: stream, lambda, Optional, functional, map, filter, reduce, method reference, CompletableFuture, Either, Result
  role: specialist
  scope: java-functional
  original-author: Juan Antonio Breña Moral
  related-skills: java-modern-features, java-exception-handling
---

# Java Functional Programming

Review and improve Java code using functional programming patterns for declarative, composable, and side-effect-free data transformations.

## When to Use This Skill

- Review or write stream pipelines
- Apply functional patterns (map, filter, reduce, compose)
- Design APIs with Optional for absent-value handling
- Implement functional exception handling (Either, Result, Try patterns)
- Refactor imperative code to functional style where beneficial

## Coverage

### Functional Programming
- Streams: declarative data transformation, collectors, `toList()` (Java 16+)
- Lambdas: extraction rules, standard functional interfaces
- Optional: correct usage as return type, chaining with `map`/`flatMap`/`filter`
- Method references for clarity
- Function composition with `andThen()`, `compose()`
- Predicate composition with `and()`, `or()`, `negate()`

### Functional Exception Handling
- Wrapping checked exceptions for lambda compatibility
- `Either<L, R>` and `Result<T, E>` patterns for error-as-value
- `Try` pattern for fallible stream operations
- Async error handling with `CompletableFuture.exceptionally()`

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Functional programming guidelines | `references/functional-programming.md` | When reviewing functional patterns |
| Functional exception handling | `references/functional-exception-handling.md` | When handling errors in functional pipelines |

## Related Rules

- `rules/java/functional-programming.mdc` -- functional programming rules
