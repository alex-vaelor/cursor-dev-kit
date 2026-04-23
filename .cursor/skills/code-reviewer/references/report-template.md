# Review Report Template

## Template

```markdown
# Code Review: [PR Title]

## Summary
[1-2 sentence overview of the changes and overall assessment]

**Verdict**: [ ] Approve | [ ] Request Changes | [ ] Comment

## Critical Issues (Must Fix)

### 1. [File:Line] Category: Description
- **Current**: What the code does now
- **Suggested**: What it should do instead
- **Impact**: Why this matters

## Major Issues (Should Fix)

### 1. [File:Line] Category: Description
- **Current**: What the code does now
- **Suggested**: Improvement
- **Impact**: Performance, maintainability, or reliability concern

## Minor Issues (Nice to Have)

### 1. [File:Line] Category: Description
- **Suggested**: Improvement

## Positive Feedback
- [Specific pattern or practice done well]

## Questions for Author
- [Specific, answerable question]

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
| Critical | Security risk, data loss, crashes | SQL injection, auth bypass |
| Major | Significant performance, maintainability | N+1 queries, god functions |
| Minor | Style, naming, small improvements | Variable names, formatting |

## Verdict Guidelines

| Verdict | When to Use |
|---------|-------------|
| Approve | No critical or major issues; minor/nit only |
| Request Changes | At least one critical or major issue |
| Comment | Questions need answers; no blocking issues |

## Time Boxing

| Section | Suggested Time |
|---------|----------------|
| Context and understanding | 5 min |
| Critical/security review | 10 min |
| Logic and performance | 15 min |
| Tests review | 10 min |
| Writing report | 10 min |
| **Total** | ~50 min |
