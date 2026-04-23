---
name: git-hooks
description: "Use when setting up Git hooks for Java/Maven projects. Automates code quality enforcement at the Git level using Maven plugins (Checkstyle, Spotless, SpotBugs), custom shell hooks, and commit message validation before code reaches CI."
risk: safe
source: consolidated
version: "1.0.0"
metadata:
  category: automation
  triggers: git hooks, pre-commit, commit-msg, pre-push, checkstyle, spotless, maven hook, githooks
  role: specialist
  scope: git-hooks-automation
  related-skills: git-commit, git-workflow, github-automation
---

# Git Hooks Automation

Automate code quality enforcement at the Git level for Java/Maven projects. Set up hooks that format, lint, test, and validate before commits and pushes reach CI.

## When to Use This Skill

- Setting up git hooks (pre-commit, commit-msg, pre-push) for Java projects
- Configuring Maven-based quality gates (Checkstyle, Spotless, SpotBugs)
- Enforcing commit message conventions with shell hooks
- Writing custom hook scripts for Java/Maven workflows
- Setting up `core.hooksPath` for team-shared hooks

## Hook Types

| Hook | Fires When | Java/Maven Use |
|------|------------|----------------|
| `pre-commit` | Before commit is created | Run Spotless check, Checkstyle, detect secrets |
| `commit-msg` | After user writes message | Enforce conventional commit format |
| `pre-push` | Before push to remote | Run `./mvnw verify`, branch name validation |
| `post-merge` | After merge completes | Rebuild project if `pom.xml` changed |
| `post-checkout` | After checkout/switch | Rebuild if build config changed |

## Quick Setup: Maven-Based Hooks

### 1. Create Shared Hooks Directory

```bash
mkdir -p .githooks
git config core.hooksPath .githooks
```

### 2. Pre-Commit Hook (Format + Lint)

```bash
#!/bin/sh
# .githooks/pre-commit
set -e

echo "=== Pre-commit: Checking code format ==="
./mvnw spotless:check -q 2>/dev/null || {
    echo "Code formatting issues found. Run: ./mvnw spotless:apply"
    exit 1
}

echo "=== Pre-commit: Checking for secrets ==="
if git diff --cached --diff-filter=ACM | grep -nEi \
    '(AKIA[0-9A-Z]{16}|password\s*=\s*["'"'"'][^"'"'"']+["'"'"'])' \
    > /dev/null 2>&1; then
    echo "Potential secrets detected in staged changes!"
    exit 1
fi

echo "Pre-commit checks passed."
```

### 3. Commit-Message Hook

```bash
#!/bin/sh
# .githooks/commit-msg
MSG=$(head -1 "$1")
PATTERN="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9\-]+\))?(!)?: [A-Z].{1,70}$"

if ! echo "$MSG" | grep -qE "$PATTERN"; then
    echo "ERROR: Commit message does not follow conventional format."
    echo "Expected: type(scope): Subject"
    echo "Got: $MSG"
    exit 1
fi
```

### 4. Pre-Push Hook (Build + Test)

```bash
#!/bin/sh
# .githooks/pre-push
set -e

BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    echo "ERROR: Cannot push directly to $BRANCH."
    exit 1
fi

echo "=== Pre-push: Running tests ==="
./mvnw verify -q
echo "All tests passed."
```

### 5. Make Hooks Executable and Document

```bash
chmod +x .githooks/*
```

Add to `README.md` or `Makefile`:
```makefile
setup:
	git config core.hooksPath .githooks
	chmod +x .githooks/*
```

## Maven Quality Plugins (CI-Side Enforcement)

Hooks are the first line of defense; Maven plugins in `pom.xml` are the source of truth.

### Spotless (Formatting)

```xml
<plugin>
    <groupId>com.diffplug.spotless</groupId>
    <artifactId>spotless-maven-plugin</artifactId>
    <version>2.44.0</version>
    <configuration>
        <java>
            <palantirJavaFormat>
                <version>2.50.0</version>
            </palantirJavaFormat>
            <removeUnusedImports/>
            <trimTrailingWhitespace/>
            <endWithNewline/>
        </java>
    </configuration>
</plugin>
```

### Checkstyle

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-checkstyle-plugin</artifactId>
    <version>3.5.0</version>
    <configuration>
        <configLocation>checkstyle.xml</configLocation>
        <failOnViolation>true</failOnViolation>
    </configuration>
    <executions>
        <execution>
            <phase>validate</phase>
            <goals><goal>check</goal></goals>
        </execution>
    </executions>
</plugin>
```

### SpotBugs (Bug Detection)

```xml
<plugin>
    <groupId>com.github.spotbugs</groupId>
    <artifactId>spotbugs-maven-plugin</artifactId>
    <version>4.8.6.6</version>
    <executions>
        <execution>
            <phase>verify</phase>
            <goals><goal>check</goal></goals>
        </execution>
    </executions>
</plugin>
```

## Key Principles

- **Staged files only** -- hooks should be fast; defer full build to pre-push
- **Auto-fix when possible** -- `spotless:apply` fixes formatting automatically
- **Fast hooks** -- pre-commit should complete in < 5 seconds
- **Team-shared** -- use `core.hooksPath` so hooks are version-controlled
- **CI as backup** -- hooks are convenience; Maven plugins in CI are the enforcer
- **Gradual adoption** -- start with formatting, add Checkstyle, then pre-push tests

## References

| Topic | File |
|-------|------|
| Hook types reference | `references/hook-types.md` |
| Maven quality setup | `references/maven-quality-setup.md` |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/install-hooks.sh` | Install and configure project hooks |

## Limitations

- Git hooks run locally and can be bypassed with `--no-verify`. Maven plugins in CI are the true enforcer.
- Hook setup assumes a Maven wrapper (`./mvnw`) is present.
- Stop and ask for clarification if the build tool or project structure is non-standard.
