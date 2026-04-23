# Spec Compliance Review

## Two-Stage Review Architecture

**Stage 1: Spec Compliance** -- does the code do the right thing?
**Stage 2: Code Quality** -- does the code do it correctly?

Complete Stage 1 before Stage 2. Never review code quality for functionality that doesn't meet the specification.

## Stage 1: Spec Compliance

Approach every review with professional skepticism. Verify claims independently.

### Three Verification Categories

#### 1. Missing Requirements

Check for features that were requested but not implemented.

| Question | How to Verify |
|----------|---------------|
| Were requested features skipped? | Compare PR to requirements line by line |
| Are edge cases handled? | Check error paths, empty states, boundaries |
| Were error scenarios addressed? | Look for try/catch, validation |
| Is the happy path complete? | Trace through primary use case |

#### 2. Unnecessary Additions

Check for scope creep and over-engineering.

| Question | How to Verify |
|----------|---------------|
| Features beyond specification? | Compare to original requirements |
| Over-engineering? | Is complexity justified? |
| Premature optimization? | Is performance cited without measurements? |
| Unrequested abstractions? | Helpers/utils for one-time use? |

#### 3. Interpretation Gaps

Check for misunderstandings of requirements.

| Question | How to Verify |
|----------|---------------|
| Different understanding? | Ask author to explain their interpretation |
| Unclarified assumptions? | Look for "assuming..." comments |
| Ambiguous specs resolved incorrectly? | Compare to existing features |

## Spec Compliance Checklist

### Before Review
- [ ] Read the original issue/ticket completely
- [ ] Identify all explicit requirements
- [ ] Note any acceptance criteria

### During Review
- [ ] All required features present
- [ ] Edge cases covered (empty, null, max values)
- [ ] Error handling as specified
- [ ] No unrequested features (scope creep)
- [ ] Assumptions are documented and valid

### After Review
- [ ] All findings documented with file:line references
- [ ] Categorized as missing/unnecessary/interpretation
- [ ] Prioritized: blocking vs non-blocking

## Output Format

### Compliant
```
## Spec Compliance: PASS
All requirements verified. Proceed to code quality review.
```

### Issues Found
```
## Spec Compliance: ISSUES FOUND

### Missing Requirements
1. [Feature X] not implemented (req #N) -- File: path:line

### Unnecessary Additions
1. [Feature Y] not in requirements -- File: path (N lines)

Action: Address missing requirements before code quality review.
```

*Content adapted from [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent (@obra), MIT License.*
