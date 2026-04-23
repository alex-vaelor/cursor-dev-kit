---
name: git-workflow
description: "Use when managing Git branches, performing rebases, cherry-picks, bisects, using worktrees, recovering lost commits, or cleaning up history before merge. Covers advanced Git operations and multi-branch workflows."
risk: critical
source: consolidated
version: "1.0.0"
metadata:
  category: workflow
  triggers: git rebase, cherry-pick, bisect, worktree, reflog, merge conflict, branch cleanup, history rewrite, git workflow
  role: specialist
  scope: git-operations
  related-skills: git-commit, git-hooks, github-pr-review
---

# Git Workflow

Advanced Git operations for managing branches, rewriting history, recovering from mistakes, and maintaining a clean repository.

## When to Use This Skill

- Cleaning up commit history before merging (interactive rebase, autosquash)
- Applying specific commits across branches (cherry-pick)
- Finding the commit that introduced a bug (bisect)
- Working on multiple features simultaneously (worktrees)
- Recovering from Git mistakes or lost commits (reflog)
- Resolving merge conflicts
- Preparing clean PRs for review
- Synchronizing diverged branches

## When Not to Use

- Simple commits and pushes (use `git-commit` skill instead)
- PR creation and review (use `github-pr-review` skill instead)
- GitHub Actions or CI/CD setup (use `github-automation` skill instead)

## Core Workflow

1. **Assess the situation** -- run `git status`, `git log --oneline -20`, and `git branch -a` to understand current state
2. **Create a safety branch** before any destructive operation: `git branch backup-$(date +%s)`
3. **Execute the operation** using the patterns from the references below
4. **Verify the result** -- run tests, check `git log`, confirm working tree is clean
5. **Clean up** -- remove backup branches and prune stale references

## Quick Reference

| Task | Command |
|------|---------|
| Interactive rebase onto main | `git rebase -i $(git merge-base HEAD main)` |
| Cherry-pick a commit | `git cherry-pick <sha>` |
| Start bisect | `git bisect start && git bisect bad && git bisect good <sha>` |
| Create worktree | `git worktree add ../hotfix-dir hotfix/branch` |
| Recover lost commit | `git reflog` then `git branch recovered <sha>` |
| Safe force push | `git push --force-with-lease origin <branch>` |
| Abort any operation | `git rebase --abort` / `git merge --abort` / `git cherry-pick --abort` |

## Safety Rules

- Always use `--force-with-lease` instead of `--force`
- Never rebase commits that have been pushed to a shared branch
- Create a backup branch before complex rebases
- Test after every history rewrite
- Reflog entries expire after 90 days -- act promptly on recovery

## References

Load detailed guidance based on context:

| Topic | File | When to Load |
|-------|------|--------------|
| Branching strategies | `references/branching-strategies.md` | Choosing or changing branch strategy |
| Merge strategies | `references/merge-strategies.md` | Deciding squash vs merge vs rebase |
| Conflict resolution | `references/conflict-resolution.md` | Resolving merge or rebase conflicts |
| Advanced Git | `references/advanced-git.md` | Bisect, worktrees, reflog, cherry-pick deep dives |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/validate-branch-name.sh` | Validates branch name against naming convention |
| `scripts/check-commit-message.sh` | Validates commit message against conventional format |
| `scripts/clean-merged-branches.sh` | Removes local and remote branches already merged into main |

## Limitations

- This skill covers Git operations only. For GitHub-specific features (PRs, Actions, API), use the `github-pr-review` or `github-automation` skills.
- Do not treat the output as a substitute for testing after history rewrites.
- Stop and ask for clarification if the operation could affect shared branches or production history.
