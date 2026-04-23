---
name: java-oop-design
description: "Use when reviewing, improving, or refactoring Java code for object-oriented design quality -- applying SOLID, DRY, YAGNI principles, improving class/interface design, fixing OOP misuse, and resolving code smells such as God Class, Feature Envy, and Data Clumps."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: oop, object-oriented, SOLID, DRY, YAGNI, class design, interface design, code smell, refactor, God Class, Feature Envy
  role: specialist
  scope: java-design
  original-author: Juan Antonio Breña Moral
  related-skills: java-type-design, java-exception-handling, java-design-patterns
---

# Java Object-Oriented Design

Review and improve Java code using comprehensive object-oriented design guidelines and refactoring practices.

## When to Use This Skill

- Review Java code for OOP design quality
- Refactor classes to follow SOLID principles
- Fix OOP concept misuse (encapsulation, inheritance, polymorphism)
- Identify and resolve code smells (God Class, Feature Envy, Data Clumps, Shotgun Surgery)
- Improve object creation patterns (static factories, builders, dependency injection)
- Improve method design (parameter validation, defensive copies, Optional usage)

## Coverage

- Fundamental design principles: SOLID, DRY, YAGNI
- Class and interface design: composition over inheritance, immutability, accessibility minimization
- Core OOP concepts: encapsulation, inheritance, polymorphism
- Object creation patterns: static factory methods, Builder, Singleton, dependency injection
- Code smells: God Class, Feature Envy, Inappropriate Intimacy, Refused Bequest, Shotgun Surgery, Data Clumps
- Method design: parameter validation, defensive copies, careful signatures, empty collections over nulls, Optional usage
- Enums and annotations: EnumSet, EnumMap, @Override consistency

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements
- **BEFORE APPLYING**: Read the reference for detailed examples, good/bad patterns, and constraints

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full OOP design guidelines | `references/oop-design-guidelines.md` | Before any OOP review or refactoring |
| Apache Commons guide | `references/apache-commons-guide.md` | When evaluating Commons vs JDK alternatives |

## Related Rules

- `rules/java/coding-standards.mdc` -- naming and formatting
- `rules/java/type-design.mdc` -- value objects and type safety
