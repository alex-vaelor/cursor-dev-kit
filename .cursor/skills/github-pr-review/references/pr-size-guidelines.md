# PR Size Guidelines

## Size Categories

| Size | Lines Changed | Review Time | Risk |
|------|---------------|-------------|------|
| XS | < 50 | 5-10 min | Minimal |
| Small | 50-200 | 15-30 min | Low |
| Medium | 200-500 | 30-60 min | Moderate |
| Large | 500-1000 | 60-120 min | High |
| XL | > 1000 | Multiple sessions | Very high |

## The 400-Line Rule

Research consistently shows that review effectiveness drops sharply after 400 lines of code. Keep PRs under 400 lines of meaningful changes whenever possible.

Exceptions:
- Generated code or migrations (tag clearly in PR description)
- Large-scale renames or moves (use `--follow` in review)
- Initial project scaffolding

## Why Small PRs Matter

- Faster review turnaround (hours instead of days)
- Higher defect detection rate
- Lower risk per merge
- Easier to revert if something goes wrong
- Less cognitive load on reviewers
- Fewer merge conflicts

## Splitting Strategies

### By Layer
```
PR 1: Add database migration and repository layer
PR 2: Add service layer with business logic
PR 3: Add API endpoints and integration tests
```

### By Feature Slice
```
PR 1: Add user registration (API + service + DB)
PR 2: Add email verification
PR 3: Add profile management
```

### Preparatory Refactoring + Feature
```
PR 1: Refactor auth module to support multiple providers
PR 2: Add OAuth2 provider using the new abstraction
```

### Stacked PRs
```
PR 1 (base): Add auth interfaces       [main ← feature/auth-interfaces]
PR 2 (stacked): Implement OAuth2        [feature/auth-interfaces ← feature/oauth]
PR 3 (stacked): Add MFA support         [feature/oauth ← feature/mfa]
```

Mark stacked PRs clearly:
```markdown
## Dependencies
This PR is stacked on #42. Review that first.
```

## What Counts as a "Line"

Focus on meaningful changes. Exclude from size consideration:
- Auto-generated files (target/, generated sources)
- Import reordering
- Pure formatting changes (run separately)
- Test fixture data files

## When Large PRs Are Unavoidable

If a PR must be large:
1. Add a detailed description with file-by-file change summary
2. Mark sections that can be reviewed independently
3. Offer to walk the reviewer through the changes
4. Consider scheduling a review session instead of async review
