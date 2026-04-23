---
name: java-type-design
description: "Use when reviewing, improving, or refactoring Java code for type design quality -- including type hierarchies, naming conventions, eliminating primitive obsession with value objects, leveraging generics, creating type-safe wrappers, designing fluent interfaces, and ensuring precision-appropriate numeric types."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: type design, value object, primitive obsession, BigDecimal, fluent interface, builder, record, sealed class, type safety
  role: specialist
  scope: java-design
  original-author: Juan Antonio Breña Moral
  related-skills: java-oop-design, java-generics, java-modern-features
---

# Java Type Design

Review and improve Java code using type design principles for maximum clarity and maintainability.

## When to Use This Skill

- Review Java code for type design quality
- Eliminate primitive obsession with domain-specific value objects
- Create type-safe wrappers and fluent interfaces
- Design type hierarchies with records and sealed classes
- Ensure precision-appropriate numeric types (BigDecimal for financial calculations)

## Coverage

- Clear type hierarchies: nested static classes, logical structure
- Consistent naming conventions: domain-driven patterns
- Type-safe wrappers: value objects replacing primitives (`EmailAddress`, `Money`)
- Generic type parameters: flexible reusable types, bounded parameters
- Domain-specific fluent interfaces: builder pattern, method chaining
- Strategic type selection: Optional, Set vs List, interfaces over concrete types
- BigDecimal for precision-sensitive calculations
- Modern Java types: records for DTOs, sealed classes for closed hierarchies

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements
- **BEFORE APPLYING**: Read the reference for detailed examples and constraints

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full type design guidelines | `references/type-design-guidelines.md` | Before any type design review |
| JSpecify null safety guide | `references/jspecify-guide.md` | When implementing or migrating null-safety annotations |

## Related Rules

- `rules/java/type-design.mdc` -- type design rules
- `rules/java/modern-features.mdc` -- records, sealed classes
