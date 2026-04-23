# Configure branch protection rules via GitHub CLI.
# Usage: .\setup-branch-protection.ps1 <owner/repo> [branch]
# Requires: gh cli authenticated

param(
    [Parameter(Mandatory)][string]$Repo,
    [string]$Branch = "main"
)
$ErrorActionPreference = "Stop"

Write-Host "Setting up branch protection for '$Branch' on '$Repo'..."

$Body = @'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["build"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_linear_history": true,
  "required_conversation_resolution": true
}
'@

$Body | gh api "repos/$Repo/branches/$Branch/protection" --method PUT --input -

Write-Host "Branch protection configured for '$Branch' on '$Repo'."
Write-Host ""
Write-Host "Verify with: gh api repos/$Repo/branches/$Branch/protection"
