# Conflict Resolution

## When Conflicts Occur

Conflicts happen when two branches modify the same lines or when one branch deletes a file that another modified. They occur during:

- `git merge`
- `git rebase`
- `git cherry-pick`
- `git stash pop`

## Resolution Workflow

### 1. Identify Conflicts

```bash
git status
# Shows files with conflicts marked as "both modified"
```

### 2. Understand the Conflict

Open the file and find conflict markers:

```
<<<<<<< HEAD
// Your changes (current branch)
const timeout = 5000;
=======
// Their changes (incoming branch)
const timeout = 10000;
>>>>>>> feature/update-timeouts
```

### 3. Resolve

Choose one side, combine both, or write something new. Remove all conflict markers.

```java
// Resolved: use the higher timeout with a constant
private static final int REQUEST_TIMEOUT_MS = 10_000;
```

### 4. Stage and Continue

```bash
git add <resolved-file>

# For merge:
git merge --continue

# For rebase:
git rebase --continue

# For cherry-pick:
git cherry-pick --continue
```

### 5. Abort if Needed

```bash
git merge --abort
git rebase --abort
git cherry-pick --abort
```

## Strategies by Situation

### Simple Text Conflicts

Both sides changed the same line. Pick one or combine.

### Structural Conflicts

One branch renamed a method, another added calls to it. Requires understanding both changes and applying the rename to the new code.

### Deleted File Conflicts

One branch deleted a file, another modified it. Decide: keep the file (with modifications) or confirm deletion.

```bash
# Keep the file
git add <file>

# Accept the deletion
git rm <file>
```

### Dependency Conflicts (pom.xml, package.json)

Both branches added dependencies. Usually both should be kept:

```bash
# Accept both additions, verify no version conflicts
git add pom.xml
```

## Prevention

- Rebase feature branches onto `main` daily to detect conflicts early
- Keep feature branches short-lived (< 3 days)
- Communicate with teammates when modifying shared files
- Use CODEOWNERS to prevent concurrent edits to critical paths
- Split large changes into smaller, focused PRs

## Tools

```bash
# Use a merge tool for complex conflicts
git mergetool

# Show the common ancestor version (3-way diff)
git merge --conflict=diff3 <branch>

# Check which commits introduced the conflict
git log --merge --oneline

# See the base version
git show :1:<file>   # common ancestor
git show :2:<file>   # ours
git show :3:<file>   # theirs
```

## Post-Resolution Checklist

- [ ] All conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) removed
- [ ] Code compiles without errors
- [ ] Tests pass
- [ ] Logic from both sides is preserved or intentionally discarded
- [ ] No duplicate imports, methods, or declarations
