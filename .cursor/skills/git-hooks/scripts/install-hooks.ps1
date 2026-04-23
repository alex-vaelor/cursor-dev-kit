# Install Git hooks for a Java/Maven project (cross-platform via PowerShell).
# Usage: .\install-hooks.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== Git Hooks Installer (Java/Maven) ==="
Write-Host ""

if (-not (Test-Path "pom.xml")) {
    Write-Host "WARNING: No pom.xml found. This script is designed for Maven projects."
    Write-Host "Proceeding with generic hook installation..."
}

if ((Test-Path "mvnw.cmd") -or (Test-Path "mvnw")) {
    $MvnCmd = if (Test-Path "mvnw.cmd") { "./mvnw.cmd" } else { "./mvnw" }
} else {
    Write-Host "WARNING: Maven Wrapper not found. Hooks will use 'mvn' directly."
    Write-Host "Recommendation: Run 'mvn wrapper:wrapper' to generate the Maven Wrapper."
    $MvnCmd = "mvn"
}

Write-Host "Setting up hooks via core.hooksPath..."
if (-not (Test-Path ".githooks")) { New-Item -ItemType Directory -Path ".githooks" -Force | Out-Null }
git config core.hooksPath .githooks

$PreCommit = @"
#!/bin/sh
set -e

echo "=== Pre-commit: Checking code format ==="
$MvnCmd spotless:check -q 2>/dev/null || {
    echo ""
    echo "Code formatting issues found."
    echo "Run: $MvnCmd spotless:apply"
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
"@
Set-Content -Path ".githooks/pre-commit" -Value $PreCommit -NoNewline

$CommitMsg = @'
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
'@
Set-Content -Path ".githooks/commit-msg" -Value $CommitMsg -NoNewline

$PrePush = @"
#!/bin/sh
set -e

BRANCH=`$(git rev-parse --abbrev-ref HEAD)
if [ "`$BRANCH" = "main" ] || [ "`$BRANCH" = "master" ]; then
    echo "ERROR: Cannot push directly to `$BRANCH. Create a PR instead."
    exit 1
fi

echo "=== Pre-push: Running tests ==="
$MvnCmd verify -q
echo "All tests passed."
"@
Set-Content -Path ".githooks/pre-push" -Value $PrePush -NoNewline

$PostMerge = @"
#!/bin/sh
CHANGED_FILES=`$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD)
if echo "`$CHANGED_FILES" | grep -q "pom.xml"; then
    echo "pom.xml changed after merge. Rebuilding..."
    $MvnCmd compile -q
fi
"@
Set-Content -Path ".githooks/post-merge" -Value $PostMerge -NoNewline

if ($IsLinux -or $IsMacOS) {
    chmod +x .githooks/pre-commit .githooks/commit-msg .githooks/pre-push .githooks/post-merge
}

Write-Host ""
Write-Host "Installed hooks:"
Write-Host "  .githooks/pre-commit   -- Spotless format check + secret scan"
Write-Host "  .githooks/commit-msg   -- Conventional commit message validation"
Write-Host "  .githooks/pre-push     -- Full Maven verify + branch protection"
Write-Host "  .githooks/post-merge   -- Rebuild on pom.xml changes"
Write-Host ""
Write-Host "core.hooksPath is set to .githooks/"
Write-Host ""
Write-Host "Done. Hooks are now active."
