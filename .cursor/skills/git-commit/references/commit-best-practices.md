# Commit Best Practices

## Atomic Commits

Each commit should represent exactly one logical change. If you can describe the commit with "and" in the message, it should probably be two commits.

**Good**: One commit adds validation, another adds error handling.
**Bad**: One commit adds validation, error handling, and updates the README.

## Commit Frequency

- Commit early and often on feature branches
- Each commit should leave the codebase in a buildable, testable state
- Squash work-in-progress commits before merging to `main`

## What Not to Commit

- Debug statements (`console.log`, `System.out.println`, `debugger`)
- Commented-out code blocks
- Generated or compiled files
- IDE-specific files (unless shared team config)
- Environment files with real secrets
- Large binary files

## Message Quality Checklist

- [ ] Uses imperative tense ("Add" not "Added" or "Adds")
- [ ] Subject starts with a capital letter
- [ ] Subject has no trailing period
- [ ] Subject is under 72 characters
- [ ] Type is from the allowed list (feat, fix, docs, etc.)
- [ ] Body explains why, not how
- [ ] Footer includes issue reference when applicable
- [ ] Breaking changes are marked with `!` and `BREAKING CHANGE:` footer

## Staging Practices

### Review Before Staging

```bash
# See what changed
git diff

# Stage interactively
git add -p
```

### Separate Concerns

```bash
# Stage only auth-related changes
git add src/auth/ tests/auth/
git commit -m "feat(auth): Add token refresh logic"

# Stage only config changes
git add config/
git commit -m "chore(config): Update timeout settings"
```

## When to Amend vs New Commit

| Situation | Action |
|-----------|--------|
| Forgot a file, not pushed yet | `git commit --amend --no-edit` |
| Typo in message, not pushed yet | `git commit --amend -m "corrected message"` |
| Already pushed | Create a new commit |
| CI failed, need to fix | New commit: `fix: Address CI failure in auth tests` |

## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| `git add . && git commit -m "updates"` | Unreviewed staging, vague message | Stage selectively, write descriptive message |
| `WIP` commits on shared branches | Pollutes history, unclear intent | Use `--fixup` and squash before merge |
| Mixing formatting + logic | Impossible to review meaningfully | Separate formatting commit from logic commit |
| Giant commits (500+ lines) | Hard to review, risky to revert | Split into atomic commits by concern |
| Commit + force push to shared branch | Destroys others' work | Never rewrite shared branch history |
