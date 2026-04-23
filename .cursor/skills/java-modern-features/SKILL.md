---
name: java-modern-features
description: "Use when refactoring Java code to use modern language features (Java 17/21) -- including records, sealed classes, pattern matching, text blocks, switch expressions, data-oriented programming, and migrating from legacy patterns to modern equivalents."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: modern java, record, sealed class, pattern matching, switch expression, text block, var, refactor to modern, data-oriented
  role: specialist
  scope: java-modernization
  original-author: Juan Antonio Breña Moral
  related-skills: java-type-design, java-functional, java-modernization
---

# Java Modern Features

Review and refactor Java code to leverage modern language features from Java 17 and 21.

## When to Use This Skill

- Refactor legacy code to use modern Java features
- Apply records, sealed classes, and pattern matching
- Implement data-oriented programming patterns
- Modernize switch statements to switch expressions
- Replace verbose patterns with concise modern equivalents

## Coverage

### Refactoring to Modern Java
- Records for DTOs and value objects
- Sealed classes for closed type hierarchies
- Pattern matching for `instanceof` and `switch`
- Switch expressions with arrow syntax
- Text blocks for multi-line strings
- Local variable type inference with `var`
- Enhanced `NullPointerException` messages (Java 17)

### Data-Oriented Programming
- Sealed interfaces + records as algebraic data types
- Pattern matching for exhaustive dispatch
- Immutable data modeling with records
- Combining functional and data-oriented approaches

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements
- **COMPATIBILITY**: Verify project's Java version before suggesting features (Java 17 minimum, Java 21 for full feature set)

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Refactoring to modern Java | `references/refactoring-to-modern-java.md` | When modernizing existing code |
| Data-oriented programming | `references/data-oriented-programming.md` | When applying data-oriented patterns |

## Related Rules

- `rules/java/modern-features.mdc` -- modern feature usage rules
