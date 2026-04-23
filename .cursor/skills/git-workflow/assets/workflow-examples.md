# Workflow Examples

## Example 1: Clean Up Feature Branch Before PR

```bash
git checkout feature/user-auth
git rebase -i main

# In the editor:
# pick abc1234 feat(auth): Add login form
# squash def5678 fix typo in login form
# squash ghi9012 another typo fix
# pick jkl3456 feat(auth): Add password validation

git push --force-with-lease origin feature/user-auth
```

## Example 2: Apply Hotfix to Multiple Releases

```bash
git checkout main
git commit -m "fix(security): Patch SQL injection in user endpoint"

HOTFIX_SHA=$(git rev-parse HEAD)
git checkout release/2.0 && git cherry-pick $HOTFIX_SHA
git checkout release/1.9 && git cherry-pick $HOTFIX_SHA
```

## Example 3: Find Bug with Bisect

```bash
git bisect start
git bisect bad HEAD
git bisect good v2.1.0

# Git checks out a middle commit -- run tests
mvn test

# If tests fail:
git bisect bad

# If tests pass:
git bisect good

# Repeat until Git identifies the commit
# Then reset:
git bisect reset
```

## Example 4: Parallel Work with Worktrees

```bash
# Main feature work in primary directory
cd ~/projects/myapp

# Create worktree for urgent bugfix
git worktree add ../myapp-hotfix hotfix/critical-bug

# Work on hotfix without interrupting main work
cd ../myapp-hotfix
git commit -m "fix: Resolve connection leak"
git push origin hotfix/critical-bug

# Return to main work
cd ~/projects/myapp
git worktree remove ../myapp-hotfix
```

## Example 5: Recover from Accidental Reset

```bash
# Mistake: accidentally reset 5 commits
git reset --hard HEAD~5

# Recovery: find lost commits in reflog
git reflog
# abc123 HEAD@{0}: reset: moving to HEAD~5
# def456 HEAD@{1}: commit: feat: important changes

# Restore
git reset --hard def456
```

## Example 6: Split a Large Commit

```bash
git rebase -i HEAD~3
# Mark the large commit with 'edit'

# Git stops at that commit
git reset HEAD^

# Commit in logical pieces
git add src/validation/ && git commit -m "feat: Add input validation"
git add src/errors/ && git commit -m "feat: Add error handling"
git add tests/ && git commit -m "test: Add validation and error tests"

git rebase --continue
```
