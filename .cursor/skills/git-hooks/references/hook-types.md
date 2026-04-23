# Git Hook Types

## Client-Side Hooks

### pre-commit
Runs before the commit message editor opens. Exit non-zero to abort.

**Common uses in Java/Maven projects:**
- Run `./mvnw spotless:check` to verify formatting
- Run Checkstyle on staged files
- Check for debug statements (`System.out.println`, `e.printStackTrace()`)
- Detect large files or committed binaries
- Scan for secrets and credentials

```bash
#!/bin/sh
set -e
./mvnw spotless:check -q
```

### prepare-commit-msg
Runs after the default message is created but before the editor opens. Receives the message file path.

**Common uses:**
- Prepopulate commit message with branch name or ticket ID
- Add template sections

```bash
#!/bin/sh
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TICKET=$(echo "$BRANCH" | grep -oE '[A-Z]+-[0-9]+' || true)
if [ -n "$TICKET" ]; then
    sed -i.bak "1s/^/[$TICKET] /" "$1"
fi
```

### commit-msg
Runs after the user writes the commit message. Receives the message file path.

**Common uses:**
- Enforce conventional commit format
- Check message length
- Validate ticket references

```bash
#!/bin/sh
MSG=$(head -1 "$1")
PATTERN="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9\-]+\))?(!)?: .{1,72}$"
if ! echo "$MSG" | grep -qE "$PATTERN"; then
    echo "ERROR: Commit message must follow conventional format: type(scope): Subject"
    exit 1
fi
```

### post-commit
Runs after the commit is created. Cannot abort the commit.

**Common uses:**
- Notifications
- Logging

### pre-push
Runs before push to remote. Exit non-zero to abort.

**Common uses in Java/Maven projects:**
- Run test suite: `./mvnw verify`
- Check branch naming conventions
- Prevent direct push to protected branches

```bash
#!/bin/sh
set -e
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    echo "ERROR: Direct push to $BRANCH is not allowed. Create a PR."
    exit 1
fi
./mvnw verify -q
```

### pre-rebase
Runs before rebase starts. Exit non-zero to abort.

**Common uses:**
- Prevent rebase on shared branches

### post-merge
Runs after a successful merge.

**Common uses in Java/Maven projects:**
- Rebuild if `pom.xml` changed
- Run Flyway/Liquibase migrations
- Refresh local environment

```bash
#!/bin/sh
CHANGED_FILES=$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD)
if echo "$CHANGED_FILES" | grep -q "pom.xml"; then
    echo "pom.xml changed. Rebuilding..."
    ./mvnw compile -q
fi
```

### post-checkout
Runs after checkout or switch.

**Common uses in Java/Maven projects:**
- Rebuild if pom.xml or build config changed
- Regenerate sources if OpenAPI specs changed

## Hook Installation

### Shared via core.hooksPath (Recommended for Java projects)
```bash
# One-time setup per developer (add to onboarding docs or Makefile)
git config core.hooksPath .githooks
chmod +x .githooks/*
```

### Native (not shared, per-developer)
```bash
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Automated via Makefile
```makefile
setup:
	git config core.hooksPath .githooks
	chmod +x .githooks/*
	./mvnw verify -DskipTests
```

## Bypassing Hooks

```bash
git commit --no-verify -m "wip: quick save"
git push --no-verify
```

If your team frequently bypasses hooks, the hooks are too slow or too strict. Pre-commit should finish in < 5 seconds.
