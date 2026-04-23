# Merge Strategies

## Overview

| Strategy | Result | History | Use When |
|----------|--------|---------|----------|
| Squash merge | Single commit on target | Linear | Feature branches, messy history |
| Merge commit | Merge commit preserving branch | Non-linear | Meaningful multi-commit branches |
| Rebase + fast-forward | Replayed commits, no merge commit | Linear | Clean, atomic commits |
| Rebase + merge commit | Rebased then merged | Semi-linear | Team preference for merge markers |

## Squash Merge (Default)

Combines all branch commits into a single commit on `main`. Produces the cleanest history.

```bash
# Via GitHub PR (preferred)
gh pr merge 42 --squash --delete-branch

# Via command line
git checkout main
git merge --squash feature/branch
git commit -m "feat(auth): Add OAuth2 login flow (#42)"
git branch -d feature/branch
```

**When to use:**
- Feature branches with work-in-progress, fixup, or messy commits
- You want one commit per feature in `main` history
- The individual commits are not meaningful on their own

**When to avoid:**
- The branch has multiple meaningful, atomic commits worth preserving

## Merge Commit

Creates an explicit merge commit that records the integration point.

```bash
gh pr merge 42 --merge --delete-branch

# Via command line
git checkout main
git merge --no-ff feature/branch
```

**When to use:**
- Release branches merging into `main`
- Multi-commit features where each commit is independently valuable
- You want to preserve the exact history of collaboration

## Rebase + Fast-Forward

Replays feature commits on top of `main`, then fast-forwards. No merge commit.

```bash
git checkout feature/branch
git rebase main
git checkout main
git merge --ff-only feature/branch
```

**When to use:**
- Feature branches with clean, atomic commits
- You want perfectly linear history
- Solo development or very small teams

**When to avoid:**
- Shared branches (rebase rewrites history)
- Branches with many conflicts (rebase resolves per-commit)

## Conflict Resolution During Merge

1. Attempt the merge: `git merge feature/branch`
2. If conflicts occur, `git status` shows conflicted files
3. Open each file, resolve `<<<<<<<` / `=======` / `>>>>>>>` markers
4. Stage resolved files: `git add <file>`
5. Complete: `git merge --continue`
6. If unsalvageable: `git merge --abort` and try a different approach

## Decision Flowchart

```
Is the branch history clean and meaningful?
├── Yes → Are commits atomic and reviewable?
│          ├── Yes → Rebase + fast-forward
│          └── No → Merge commit
└── No → Squash merge
```

## Team Configuration

Configure the default merge strategy in GitHub repository settings:
- Settings > General > Pull Requests
- Enable: "Allow squash merging" (default commit message: PR title + description)
- Enable: "Allow merge commits" (for release merges)
- Disable: "Allow rebase merging" (unless the team is experienced with rebase)
- Enable: "Automatically delete head branches"
