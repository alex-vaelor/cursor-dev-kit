---
name: java-code-review
description: "Use when conducting Java-specific code reviews -- applying Java coding standards, identifying Java-specific anti-patterns, running static analysis (Checkstyle, SpotBugs), and producing actionable review feedback for Java projects."
risk: safe
source: extended
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: quality
  triggers: java review, java code review, java PR, checkstyle, spotbugs, PMD, static analysis, java audit
  role: specialist
  scope: java-code-review
  related-skills: code-reviewer, java-oop-design, java-testing
---

# Java Code Review

Conduct thorough Java-specific code reviews that check coding standards, design quality, testing, security, and performance using both manual inspection and automated tools.

## When to Use This Skill

- Reviewing pull requests for Java projects
- Conducting code quality audits on Java codebases
- Running static analysis tools (Checkstyle, SpotBugs, PMD)
- Checking Java-specific anti-patterns and best practices
- Validating adherence to project conventions

## Core Workflow

1. **Context**: Read PR description, understand the change. Check which Java/Spring skills are relevant.
2. **Automated checks**: Run Checkstyle and SpotBugs if configured in the project.
3. **Standards**: Verify naming, formatting, import ordering against `shared/java-conventions.md`.
4. **Design**: Check OOP principles, type design, exception handling patterns.
5. **Modern Java**: Verify modern feature usage (records, sealed classes, pattern matching where applicable).
6. **Testing**: Validate test coverage, test quality, and testing patterns.
7. **Security**: Check for OWASP Top 10 issues, input validation, secrets exposure.
8. **Performance**: Look for N+1 queries, unnecessary object creation, missing indices.
9. **Report**: Produce categorized feedback using severity tags.

## Java-Specific Review Checklist

| Area | What to Check |
|------|---------------|
| **Naming** | Package, class, method, variable naming conventions |
| **Null Safety** | JSpecify annotations, Optional usage, null checks |
| **Immutability** | Records for DTOs, final fields, defensive copies |
| **DI** | Constructor injection only, final dependencies |
| **Exceptions** | Specific types, try-with-resources, no swallowed exceptions |
| **Concurrency** | Thread safety, virtual thread compatibility, lock discipline |
| **Generics** | No raw types, PECS wildcards, type inference |
| **Modern Java** | Records, sealed classes, pattern matching where applicable |
| **Spring** | Correct annotations, proper layering, configuration patterns |
| **Testing** | Coverage, Given-When-Then structure, no anti-patterns |

## Constraints

- Summarize PR intent before reviewing
- Provide specific, actionable feedback with file and line references
- Include code examples in suggestions
- Prioritize: [CRITICAL] > [MAJOR] > [MINOR] > [NIT]
- Always include at least one positive observation

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Java review checklist | `references/java-review-checklist.md` | Starting any Java review |
| Java style guide | `references/java-style-guide.md` | Checking naming and formatting |
| Clean code checklist | `references/clean-code-checklist.md` | Reviewing for clean code principles |
| Review culture guide | `references/review-culture-guide.md` | Establishing review norms and feedback patterns |
| Systematic review checklist | `references/systematic-review-checklist.md` | Comprehensive step-by-step review (design through docs) |
| Security review checklist | `references/security-review-checklist.md` | Security-focused review (OWASP Top 10) |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/run-checkstyle.sh` | Run Checkstyle analysis |
| `scripts/run-spotbugs.sh` | Run SpotBugs analysis |

## Related Skills

- `skills/code-reviewer/` -- general code review process
- `skills/java-oop-design/` -- OOP design guidelines
- `skills/java-testing/` -- testing quality
