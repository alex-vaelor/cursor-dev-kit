# Validate that the current or given branch name follows conventions.
# Usage: .\validate-branch-name.ps1 [branch_name]

param([string]$Branch = "")
$ErrorActionPreference = "Stop"

if (-not $Branch) { $Branch = git rev-parse --abbrev-ref HEAD }

$Pattern = "^(feature|bugfix|hotfix|release|chore|docs|refactor|test|experiment)/[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]$"
$SpecialBranches = "^(main|master|develop|staging)$"

if ($Branch -match $SpecialBranches) {
    Write-Host "OK: '$Branch' is a protected branch name."
    exit 0
}

if ($Branch -match $Pattern) {
    Write-Host "OK: '$Branch' follows naming conventions."
    exit 0
} else {
    Write-Host "ERROR: '$Branch' does not follow naming conventions."
    Write-Host ""
    Write-Host "Expected pattern: <type>/<ticket-id>-<description>"
    Write-Host "  Types: feature, bugfix, hotfix, release, chore, docs, refactor, test, experiment"
    Write-Host "  Use lowercase with hyphens. Ticket IDs may be uppercase (e.g. AUTH-42)."
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  feature/AUTH-42-add-oauth-login"
    Write-Host "  bugfix/API-99-fix-null-response"
    Write-Host "  chore/update-dependencies"
    exit 1
}
