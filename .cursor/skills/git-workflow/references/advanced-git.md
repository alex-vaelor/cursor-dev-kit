# Advanced Git Operations

## Interactive Rebase

The Swiss Army knife of history editing. Use to squash, reword, reorder, or drop commits.

### Operations

| Command | Effect |
|---------|--------|
| `pick` | Keep commit as-is |
| `reword` | Change commit message |
| `edit` | Amend commit content |
| `squash` | Combine with previous commit (keep both messages) |
| `fixup` | Combine with previous commit (discard this message) |
| `drop` | Remove commit entirely |

### Usage

```bash
# Rebase last N commits
git rebase -i HEAD~5

# Rebase all commits on current branch since diverging from main
git rebase -i $(git merge-base HEAD main)

# Autosquash fixup commits
git commit --fixup <sha>
git rebase -i --autosquash main
```

### Split a Commit

```bash
git rebase -i HEAD~3
# Mark commit with 'edit'
# Git stops at that commit
git reset HEAD^
git add file1.py && git commit -m "feat: add validation"
git add file2.py && git commit -m "feat: add error handling"
git rebase --continue
```

## Cherry-Pick

Apply specific commits from one branch to another.

```bash
# Single commit
git cherry-pick <sha>

# Range of commits (exclusive start)
git cherry-pick <start-sha>..<end-sha>

# Without committing (stage changes only)
git cherry-pick -n <sha>

# Specific files from a commit
git checkout <sha> -- path/to/file
git commit -m "cherry-pick: apply changes from <sha>"
```

### Hotfix Across Releases

```bash
git checkout main && git commit -m "fix: critical security patch"
git checkout release/2.0 && git cherry-pick <sha>
git checkout release/1.9 && git cherry-pick <sha>
```

## Bisect

Binary search to find the commit that introduced a bug.

```bash
# Manual bisect
git bisect start
git bisect bad HEAD
git bisect good v1.0.0
# Test, then: git bisect good OR git bisect bad
# Repeat until found
git bisect reset

# Automated bisect
git bisect start HEAD v1.0.0
git bisect run ./test.sh
# test.sh exits 0 for good, 1-127 (except 125) for bad, 125 for skip
```

## Worktrees

Work on multiple branches simultaneously without stashing or switching.

```bash
# Create worktree for existing branch
git worktree add ../project-hotfix hotfix/critical

# Create worktree with new branch
git worktree add -b bugfix/urgent ../project-bugfix main

# List worktrees
git worktree list

# Remove worktree
git worktree remove ../project-hotfix

# Prune stale entries
git worktree prune
```

## Reflog

Tracks all ref movements for 90 days, including deleted commits and branches.

```bash
# View reflog
git reflog

# Recover deleted commit
git reflog
git branch recovered <sha>

# Recover from bad reset
git reset --hard HEAD~5   # mistake
git reflog                 # find the sha before reset
git reset --hard <sha>     # undo the reset

# View reflog for specific branch
git reflog show feature/branch
```

## Stash Operations

```bash
# Stash with message
git stash push -m "WIP: auth flow"

# Stash specific files
git stash push -m "partial" -- src/auth.ts

# List stashes
git stash list

# Apply and keep stash
git stash apply stash@{0}

# Apply and remove stash
git stash pop

# Create branch from stash
git stash branch feature/from-stash stash@{0}
```

## Recovery Commands

```bash
# Abort any in-progress operation
git rebase --abort
git merge --abort
git cherry-pick --abort
git bisect reset

# Undo last commit, keep changes staged
git reset --soft HEAD^

# Undo last commit, keep changes unstaged
git reset HEAD^

# Restore file to specific version
git restore --source=<sha> path/to/file

# Recover deleted branch (within 90 days)
git reflog
git branch <branch-name> <sha>
```
