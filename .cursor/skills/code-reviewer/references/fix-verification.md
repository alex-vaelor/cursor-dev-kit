# Fix Verification Guide

## Purpose

Verify that audit-identified issues have been correctly addressed in fix commits. This ensures fixes are complete, don't introduce regressions, and follow the agreed remediation plan.

## Verification Workflow

1. **Recall the original finding** -- re-read the audit finding (severity, location, recommended fix)
2. **Inspect the fix commit** -- review only the diff for the fix; don't re-review unrelated code
3. **Verify completeness** -- confirm the fix addresses the root cause, not just symptoms
4. **Check for regressions** -- ensure the fix doesn't break existing behavior
5. **Validate tests** -- confirm a test exists that would fail if the fix were reverted
6. **Approve or re-flag** -- mark finding as resolved or explain why it's still open

## Verification Checklist

### Fix Correctness
- [ ] Fix addresses the root cause identified in the original finding
- [ ] Fix matches the recommended remediation (or alternative is justified)
- [ ] Fix applies to all instances of the issue (not just the one flagged)
- [ ] No new code smells introduced by the fix

### Regression Safety
- [ ] Existing tests still pass
- [ ] New test covers the specific scenario from the finding
- [ ] Test would fail if the fix were reverted (regression test)
- [ ] Edge cases from the original finding are covered

### Security Fix Verification
- [ ] Parameterized queries replace string concatenation (SQL injection fixes)
- [ ] Input validation added at the trust boundary, not deeper
- [ ] Secrets removed from code, not just moved to a different file
- [ ] Authentication/authorization checks cannot be bypassed via alternative paths
- [ ] Fix applies to all similar patterns in the codebase (not just the flagged instance)

### Performance Fix Verification
- [ ] N+1 query fix uses `JOIN FETCH` or batch loading, not just additional queries
- [ ] Caching fix has invalidation strategy
- [ ] Index added to database (check migration file)
- [ ] Benchmark or load test confirms improvement

## Verification Report Template

```markdown
## Fix Verification: [Finding ID]

**Original Finding**: [Brief description]
**Severity**: [CRITICAL/MAJOR/MINOR]
**Fix Commit**: [commit SHA]

### Assessment
- **Root cause addressed**: Yes / No / Partial
- **Regression test added**: Yes / No
- **All instances fixed**: Yes / No (X of Y)

### Verdict
- [ ] **RESOLVED** -- Fix is complete and verified
- [ ] **PARTIALLY RESOLVED** -- Fix addresses the main case but misses [details]
- [ ] **NOT RESOLVED** -- Fix does not address the root cause because [reason]
- [ ] **NEW ISSUE** -- Fix introduces a new problem: [description]

### Notes
[Any additional context or recommendations]
```

## Common Fix Pitfalls

| Pitfall | Example | What to Check |
|---------|---------|---------------|
| Symptom fix | Adding null check instead of fixing root null source | Trace back to where the null originates |
| Partial fix | Fixing one SQL injection but missing 3 others | Search codebase for same pattern |
| Fix that moves the problem | Moving a secret from code to an unencrypted config file | Verify secrets use environment variables or vault |
| Over-fix | Catching `Exception` to prevent one specific error | Verify exception handling is appropriately scoped |
| Missing test | Fix applied but no regression test | Revert fix mentally and ask: would any test fail? |
