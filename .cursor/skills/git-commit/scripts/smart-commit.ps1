# Commit with conventional commit message validation and branch safety.
# Usage: .\smart-commit.ps1 '<commit-message>'
#   Example: .\smart-commit.ps1 'feat(auth): Add OAuth2 login'

param(
    [Parameter(Mandatory)][string]$Message
)
$ErrorActionPreference = "Stop"

$Header = ($Message -split "`n")[0]
$Pattern = "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9\-]+\))?(!)?: [A-Z].{1,70}$"

if ($Header -notmatch $Pattern) {
    Write-Error "Commit message does not follow conventional format.`nExpected: <type>(<scope>): <Subject>`nGot: $Header"
    exit 1
}

$Branch = git rev-parse --abbrev-ref HEAD
if ($Branch -eq "main" -or $Branch -eq "master") {
    Write-Error "Cannot commit directly to '$Branch'. Create a feature branch first."
    exit 1
}

$Staged = git diff --cached --name-only
if (-not $Staged) {
    Write-Host "No staged changes. Staging all tracked changes..."
    git add -u
}

$Staged = git diff --cached --name-only
if (-not $Staged) {
    Write-Error "No changes to commit."
    exit 1
}

git commit --trailer "Made-with: Cursor" -m $Message
Write-Host ""
Write-Host "Committed to '$Branch'. Push with: git push -u origin $Branch"
