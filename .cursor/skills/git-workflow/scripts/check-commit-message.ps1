# Validate a commit message against conventional commit format.
# Usage: .\check-commit-message.ps1 <commit-message-file>
#   Typically called as a commit-msg hook with .git/COMMIT_EDITMSG

param(
    [Parameter(Mandatory)][string]$MsgFile
)
$ErrorActionPreference = "Stop"

$Msg = (Get-Content $MsgFile -TotalCount 1)
$Pattern = "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9\-]+\))?(!)?: [A-Z].{1,70}$"

if ($Msg -match $Pattern) {
    Write-Host "OK: Commit message follows conventional format."
    exit 0
} else {
    Write-Host "ERROR: Commit message does not follow conventional format."
    Write-Host ""
    Write-Host "Expected: <type>(<optional-scope>): <Subject starting with capital>"
    Write-Host "  Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert"
    Write-Host "  Subject must start with a capital letter and be <= 72 characters."
    Write-Host ""
    Write-Host "Got: $Msg"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  feat(auth): Add OAuth2 PKCE flow"
    Write-Host "  fix: Handle null response in user endpoint"
    Write-Host "  docs: Update API usage guide"
    exit 1
}
