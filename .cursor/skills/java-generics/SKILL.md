---
name: java-generics
description: "Use when reviewing, improving, or applying Java generics -- including type-safe API design, bounded type parameters, wildcards (PECS), type erasure awareness, generic methods, and eliminating raw types and unchecked casts."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: generics, type parameter, wildcard, PECS, type erasure, raw type, unchecked cast, bounded type
  role: specialist
  scope: java-generics
  original-author: Juan Antonio Breña Moral
  related-skills: java-type-design, java-oop-design
---

# Java Generics

Review and improve Java code using generics best practices for type-safe, reusable APIs.

## When to Use This Skill

- Review Java code for generics correctness
- Design type-safe generic APIs and data structures
- Apply PECS (Producer Extends, Consumer Super) wildcard rules
- Eliminate raw types and unchecked casts
- Understand and work around type erasure limitations

## Coverage

- Bounded type parameters and recursive type bounds
- Wildcards: PECS principle for flexible API design
- Type erasure awareness and workarounds
- Generic methods vs generic classes
- Raw type elimination
- Unchecked cast safety
- Type inference and diamond operator

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements
- **BEFORE APPLYING**: Read the reference for detailed examples and constraints

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full generics guidelines | `references/generics-guidelines.md` | Before any generics review |

## Related Rules

- `rules/java/generics.mdc` -- generics rules
