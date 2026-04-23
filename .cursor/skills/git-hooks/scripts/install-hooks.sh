#!/bin/bash
set -e

echo "=== Git Hooks Installer (Java/Maven) ==="
echo ""

if [ ! -f "pom.xml" ]; then
  echo "WARNING: No pom.xml found. This script is designed for Maven projects."
  echo "Proceeding with generic hook installation..."
fi

if [ ! -f "mvnw" ] && [ ! -f "mvnw.cmd" ]; then
  echo "WARNING: Maven Wrapper not found. Hooks will use 'mvn' directly."
  echo "Recommendation: Run 'mvn wrapper:wrapper' to generate the Maven Wrapper."
  MVN_CMD="mvn"
else
  MVN_CMD="./mvnw"
fi

echo "Setting up hooks via core.hooksPath..."
mkdir -p .githooks
git config core.hooksPath .githooks

cat > .githooks/pre-commit << PREHOOK
#!/bin/sh
set -e

echo "=== Pre-commit: Checking code format ==="
$MVN_CMD spotless:check -q 2>/dev/null || {
    echo ""
    echo "Code formatting issues found."
    echo "Run: $MVN_CMD spotless:apply"
    exit 1
}

echo "=== Pre-commit: Checking for secrets ==="
if git diff --cached --diff-filter=ACM | grep -nEi \
    '(AKIA[0-9A-Z]{16}|password\s*=\s*["'"'"'][^"'"'"']+["'"'"']|BEGIN (RSA|DSA|EC) PRIVATE KEY)' \
    > /dev/null 2>&1; then
    echo "Potential secrets detected in staged changes!"
    exit 1
fi

echo "Pre-commit checks passed."
PREHOOK
chmod +x .githooks/pre-commit

cat > .githooks/commit-msg << 'MSGHOOK'
#!/bin/sh
MSG=$(head -1 "$1")
PATTERN="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9\-]+\))?(!)?: .{1,72}$"

if ! echo "$MSG" | grep -qE "$PATTERN"; then
    echo ""
    echo "ERROR: Commit message does not follow conventional format."
    echo "Expected: type(scope): Subject"
    echo "Examples:"
    echo "  feat(auth): Add JWT token refresh endpoint"
    echo "  fix(order): Prevent duplicate order submission"
    echo "  docs: Update API documentation"
    echo ""
    echo "Got: $MSG"
    exit 1
fi
MSGHOOK
chmod +x .githooks/commit-msg

cat > .githooks/pre-push << PUSHHOOK
#!/bin/sh
set -e

BRANCH=\$(git rev-parse --abbrev-ref HEAD)
if [ "\$BRANCH" = "main" ] || [ "\$BRANCH" = "master" ]; then
    echo "ERROR: Cannot push directly to \$BRANCH. Create a PR instead."
    exit 1
fi

echo "=== Pre-push: Running tests ==="
$MVN_CMD verify -q
echo "All tests passed."
PUSHHOOK
chmod +x .githooks/pre-push

cat > .githooks/post-merge << MERGEHOOK
#!/bin/sh
CHANGED_FILES=\$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD)
if echo "\$CHANGED_FILES" | grep -q "pom.xml"; then
    echo "pom.xml changed after merge. Rebuilding..."
    $MVN_CMD compile -q
fi
MERGEHOOK
chmod +x .githooks/post-merge

echo ""
echo "Installed hooks:"
echo "  .githooks/pre-commit   -- Spotless format check + secret scan"
echo "  .githooks/commit-msg   -- Conventional commit message validation"
echo "  .githooks/pre-push     -- Full Maven verify + branch protection"
echo "  .githooks/post-merge   -- Rebuild on pom.xml changes"
echo ""
echo "core.hooksPath is set to .githooks/"
echo ""
echo "Add to your project README or Makefile:"
echo "  git config core.hooksPath .githooks"
echo "  chmod +x .githooks/*"
echo ""
echo "Done. Hooks are now active."
