---
name: git-commit
description: "Use when committing code changes, writing commit messages, splitting commits, amending history, or enforcing conventional commit format. Covers commit creation, message conventions, and pre-commit safety checks."
risk: critical
source: consolidated
version: "1.0.0"
metadata:
  category: workflow
  triggers: git commit, commit message, conventional commit, commit code, save changes, amend commit, split commit
  role: specialist
  scope: git-commits
  related-skills: git-workflow, git-hooks, changelog-release
---

# Git Commit

Create well-structured, conventional commits that are atomic, reviewable, and meaningful.

## When to Use This Skill

- Committing code changes
- Writing or improving commit messages
- Splitting large commits into atomic units
- Amending recent commits
- Enforcing commit conventions

## Prerequisites

Before committing, always check the current branch:

```bash
git branch --show-current
```

If on `main` or `master`, create a feature branch first. Do not commit directly to protected branches unless explicitly instructed.

## Commit Workflow

1. **Check branch** -- verify you are on a feature branch, not `main`
2. **Review changes** -- `git diff --staged` to see what will be committed
3. **Stage selectively** -- `git add -p` for partial staging, not `git add .`
4. **Write message** -- follow conventional commit format (see below)
5. **Verify** -- `git log -1` to confirm the commit looks correct

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructuring, no behavior change |
| `perf` | Performance improvement |
| `docs` | Documentation only |
| `test` | Adding or correcting tests |
| `build` | Build system or dependencies |
| `ci` | CI configuration |
| `chore` | Maintenance tasks |
| `style` | Code formatting, no logic change |
| `revert` | Reverting a previous commit |

### Rules

- Subject line: imperative tense, capitalized, no period, max 72 characters
- Body: explain what and why, not how. Wrap at 100 characters.
- Footer: issue references (`Fixes #123`, `Refs GH-456`) and breaking changes

## Selective Staging

```bash
# Stage specific files
git add src/main/java/com/example/auth/LoginService.java src/test/java/com/example/auth/LoginServiceTest.java

# Interactive partial staging
git add -p

# Stage all tracked changes (skip untracked)
git add -u
```

Never use `git add .` blindly. Review what you are staging.

## Splitting Commits

When a change is too large for one commit:

```bash
git add src/main/java/com/example/validation/ && git commit -m "feat: Add input validation"
git add src/main/java/com/example/exception/ && git commit -m "feat: Add error handling"
git add src/test/ && git commit -m "test: Cover validation and error cases"
```

## Amending

```bash
# Amend the last commit message
git commit --amend -m "fix(auth): Return 401 for expired tokens"

# Add forgotten files to last commit
git add src/main/java/com/example/auth/TokenValidator.java
git commit --amend --no-edit
```

Only amend commits that have not been pushed. If pushed, create a new commit instead.

## References

| Topic | File |
|-------|------|
| Conventional Commits spec | `references/conventional-commits.md` |
| Commit best practices | `references/commit-best-practices.md` |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/smart-commit.sh` | Stage, commit, and push with validation |

## Limitations

- This skill covers commit creation only. For history rewriting (rebase, cherry-pick), use the `git-workflow` skill.
- Do not amend commits that have been pushed to a shared branch.
- Stop and ask for clarification if the commit scope is unclear or spans multiple concerns.
