# Code Review Report Template

```markdown
# Code Review: [PR Title]

## Summary
[1-2 sentence overview of the changes and overall assessment]

**Verdict**: [ ] Approve | [ ] Request Changes | [ ] Comment

## Critical Issues (Must Fix)

### 1. [File:Line] Category: Description
- **Current**: What the code does now
- **Suggested**: What it should do instead
- **Impact**: Why this matters (security, data loss, crash)

## Major Issues (Should Fix)

### 1. [File:Line] Category: Description
- **Current**: What the code does now
- **Suggested**: What it should do instead
- **Impact**: Performance, maintainability, or reliability concern

## Minor Issues (Nice to Have)

### 1. [File:Line] Category: Description
- **Current**: Current state
- **Suggested**: Improvement

## Positive Feedback
- [Specific pattern or practice done well]
- [Another specific positive observation]

## Questions for Author
- [Specific, answerable question about intent or design]

## Test Coverage Assessment
- [ ] Happy path tested
- [ ] Error cases tested
- [ ] Edge cases tested
- [ ] Integration tests present

## Checklist
- [ ] No security vulnerabilities
- [ ] Performance is acceptable
- [ ] Code is readable
- [ ] Tests are adequate
- [ ] Documentation is present
```

## Severity Definitions

| Severity | Definition | Examples |
|----------|------------|----------|
| Critical | Security risk, data loss, crashes | SQL injection, auth bypass, null dereference |
| Major | Performance, maintainability | N+1 queries, god functions, missing error handling |
| Minor | Style, naming, readability | Variable names, formatting, minor refactors |

## Verdict Guidelines

| Verdict | When to Use |
|---------|-------------|
| Approve | No critical or major issues; minor/nit suggestions only |
| Request Changes | At least one critical or major issue that must be addressed |
| Comment | Questions need answers; no blocking issues found yet |
