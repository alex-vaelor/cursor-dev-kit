# Review Feedback Guide

## Feedback Quality Principles

1. **Be specific** -- reference class, method, and line number
2. **Be actionable** -- suggest a concrete fix or alternative
3. **Be constructive** -- frame as improvement, not criticism
4. **Explain why** -- "This risks N+1 queries because..." not just "Fix the query"
5. **Ask, don't assume** -- "Is this intentional?" when behavior seems off

## Severity Tags

Always prefix feedback with a severity tag:

| Tag | Meaning | Author Action |
|-----|---------|---------------|
| `[CRITICAL]` | Security risk, data loss, crash | Must fix before merge |
| `[MAJOR]` | Performance, design, missing error handling | Should fix before merge |
| `[MINOR]` | Naming, readability, style | Fix at discretion |
| `[NIT]` | Trivial preference | No action required |
| `[QUESTION]` | Clarification needed | Must respond |
| `[PRAISE]` | Positive reinforcement | No action required |

## Good vs Bad Feedback

### Be Specific
```
BAD: "This is confusing"

GOOD: "OrderService.processOrder() handles both validation and persistence.
Consider splitting into validateOrder() and saveOrder() for single
responsibility and easier testing."
```

### Be Actionable
```
BAD: "Fix the query"

GOOD: "[MAJOR] Performance: N+1 Query at PostService:23
Current code calls userRepository.findById() inside a loop. Use JOIN FETCH:
  @Query("SELECT p FROM Post p JOIN FETCH p.author")
  List<Post> findAllWithAuthors();
Impact: ~100 extra DB queries per request."
```

### Ask Questions
```
BAD: "This is wrong"

GOOD: "[QUESTION] I notice findUser() returns Optional.empty() instead of
throwing UserNotFoundException. Is that intentional? The other repository
methods throw on not-found. Should this be consistent?"
```

## Praise Examples

Always include at least one specific praise:

```
[PRAISE] Great use of guard clauses here -- much more readable than nested ifs.
[PRAISE] Nice use of records for this DTO -- immutable by default.
[PRAISE] Excellent exception hierarchy with clear domain-specific error messages.
[PRAISE] Good choice using @Transactional(readOnly = true) for the query path.
```

## Summary Format

```markdown
## Summary
Overall this is a solid implementation of the user registration flow.
The Bean Validation annotations are clean and the @ControllerAdvice
exception handling is comprehensive.

**Blocking Issues**: 1 critical (SQL injection in UserRepository)
**Suggestions**: 2 major, 3 minor

Once the SQL injection is fixed, this is ready to merge.
```

## Handling Disagreement

When the author disagrees with feedback:

- Listen to their reasoning -- they may know context you don't
- If technically valid, concede gracefully
- If you still disagree, escalate to a third reviewer
- Never block a PR over subjective preferences
