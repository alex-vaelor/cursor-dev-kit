---
name: tdd-workflow
description: "Use when applying Test-Driven Development -- including Red-Green-Refactor cycle, London style (outside-in) and Chicago style (inside-out) TDD, test prioritization, TDD anti-patterns, and AI-augmented TDD patterns."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: TDD, test-driven development, red green refactor, outside-in, inside-out, test first, failing test
  role: specialist
  scope: tdd
  related-skills: java-testing, spring-boot-testing
---

# TDD Workflow

Apply Test-Driven Development using the Red-Green-Refactor cycle for robust, well-designed code.

## When to Use This Skill

- Implement new features using TDD
- Fix bugs with test-first approach (write failing test that reproduces the bug)
- Refactor with safety net (ensure tests pass before and after)
- Design APIs by writing consumer tests first (London style)
- Build domain logic with incremental test coverage (Chicago style)

## The Three Laws of TDD

1. Write production code only to make a failing test pass
2. Write only enough test to demonstrate a failure
3. Write only enough production code to make the test pass

## The Cycle

```
RED -> GREEN -> REFACTOR -> repeat
```

### RED Phase
- Write a test that describes the expected behavior
- Test must fail (compile error counts as failing)
- Test name describes the behavior: `shouldCalculateTotalWithDiscount`
- One assertion concept per test

### GREEN Phase
- Write the minimum code to make the test pass
- YAGNI: do not add code the test doesn't require
- No optimization; just make it work
- Commit after green

### REFACTOR Phase
- Improve code quality: extract methods, rename, remove duplication
- All tests must stay green throughout
- Small incremental changes; run tests after each refactoring step
- Commit after each successful refactor

## Styles

| Style | Direction | Best For |
|-------|-----------|----------|
| **London (Outside-In)** | Start from controller/API, mock dependencies, work inward | Feature implementation, API-first design |
| **Chicago (Inside-Out)** | Start from domain/model, no mocks at first, work outward | Domain logic, algorithmic code |

## Test Prioritization

1. Happy path (core behavior)
2. Error cases (invalid input, failures)
3. Edge cases (boundaries, empty, null)
4. Performance (only when behavior is stable)

## Anti-Patterns

- Skipping the RED phase (test must fail first)
- Writing tests after the code
- Over-engineering in the GREEN phase
- Multiple assertions testing unrelated behaviors
- Testing implementation details instead of behavior

## Constraints

- **MANDATORY**: Run `./mvnw compile` before starting TDD cycle
- **VERIFY**: Run `./mvnw clean verify` after completing a feature
- Always commit at GREEN before refactoring

## References

| Topic | File | When to Load |
|-------|------|--------------|
| TDD cycle details | `references/tdd-cycle.md` | When applying full Red-Green-Refactor |
| TDD anti-patterns | `references/tdd-anti-patterns.md` | When reviewing TDD practices |

## Related Rules

- `rules/testing/tdd-workflow.mdc` -- TDD rules
- `rules/testing/unit-testing.mdc` -- unit test conventions

## Related Skills

- `skills/java-testing/` -- Java testing guidelines
- `skills/spring-boot-testing/` -- Spring testing
