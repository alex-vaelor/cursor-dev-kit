---
name: code-refactoring
description: "Use when refactoring Java code or managing technical debt -- including SOLID-guided refactoring, code smell identification, safe incremental refactoring patterns, tech debt quantification, and modernization of legacy patterns to Java 17/21."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: quality
  triggers: refactor, tech debt, code smell, clean code, SOLID, extract method, dead code, legacy, simplify, modernize
  role: specialist
  scope: java-refactoring
  related-skills: java-code-review, java-oop-design, java-modern-features, java-design-patterns
---

# Code Refactoring

Systematically improve Java code quality through SOLID-guided refactoring and tech debt management.

## When to Use This Skill

- Refactor code to remove smells (long methods, large classes, feature envy, primitive obsession)
- Apply SOLID principles to improve design
- Identify, quantify, and prioritize technical debt
- Modernize legacy Java patterns to Java 17/21 idioms
- Reduce complexity without changing behavior
- Prepare code for new features by improving structure first

## Refactoring Workflow

1. **Assess**: Identify code smells and design violations with static analysis
2. **Prioritize**: Score by impact (bug risk, maintenance cost, change frequency)
3. **Plan**: Define safe, incremental steps; never refactor and add features simultaneously
4. **Test**: Ensure existing tests pass; add tests for uncovered code before refactoring
5. **Execute**: Small, focused changes; compile and test after each step
6. **Verify**: Run full suite (`./mvnw clean verify`); confirm behavior is unchanged

## Code Smells (Java-Specific)

| Smell | Detection | Refactoring |
|-------|-----------|-------------|
| Long method (>20 lines) | SpotBugs, manual review | Extract Method, Compose Method |
| Large class (>300 lines) | Line count, SRP violation | Extract Class, Move Method |
| Feature envy | Method uses another object's data more than its own | Move Method to the data owner |
| Primitive obsession | Raw `String`/`int` for domain concepts | Extract to record or value object |
| Data clump | Same group of fields passed together | Extract record/class for the group |
| God class / Blob | One class does everything | Decompose by responsibility |
| Switch on type | `if/else` or `switch` over class type | Sealed interface + pattern matching |
| Mutable DTO | Setters on transfer objects | Convert to record |

## Tools

| Tool | Purpose | Command |
|------|---------|---------|
| Checkstyle | Style and complexity violations | `./mvnw checkstyle:check` |
| SpotBugs | Bug patterns and code smells | `./mvnw spotbugs:check` |
| PMD | Copy-paste detection, complexity | `./mvnw pmd:check` |
| SonarQube | Comprehensive quality dashboard | `mvn sonar:sonar` |
| JaCoCo | Coverage gaps before refactoring | `./mvnw jacoco:report` |
| IntelliJ IDEA | Automated refactoring (Extract, Inline, Rename) | IDE refactoring menu |

## Constraints

- **MANDATORY**: Run `./mvnw compile` before and after each refactoring step
- **VERIFY**: Run `./mvnw clean verify` after completing a refactoring session
- **NEVER** refactor and change behavior in the same commit
- **ALWAYS** have passing tests before starting; add tests first if coverage is low

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Refactoring patterns and SOLID examples | `references/refactoring-patterns.md` | When applying specific refactoring techniques |
| Tech debt management | `references/tech-debt-management.md` | When quantifying or prioritizing tech debt |

## Related Rules

- `rules/java/coding-standards.mdc` -- coding standards
- `rules/java/modern-features.mdc` -- modern Java patterns
- `rules/java/type-design.mdc` -- value objects and type hierarchies

## Related Skills

- `skills/java-code-review/` -- review criteria
- `skills/java-oop-design/` -- OOP design guidelines
- `skills/java-design-patterns/` -- pattern application
- `skills/java-modern-features/` -- modernization targets
