# Remove local and remote branches that have been merged into the main branch.
# Usage: .\clean-merged-branches.ps1 [main_branch] [-DryRun]

param(
    [string]$MainBranch = "main",
    [switch]$DryRun
)
$ErrorActionPreference = "Stop"

Write-Host "Cleaning branches already merged into '$MainBranch'..."

git fetch --prune origin

Write-Host ""
Write-Host "=== Local merged branches ==="
$LocalMerged = git branch --merged $MainBranch |
    ForEach-Object { $_.Trim().TrimStart("* ") } |
    Where-Object { $_ -and $_ -notmatch "^(main|master|develop|staging)$" }

if (-not $LocalMerged) {
    Write-Host "  No local merged branches to clean."
} else {
    $LocalMerged | ForEach-Object { Write-Host "  $_" }
    if (-not $DryRun) {
        $LocalMerged | ForEach-Object { git branch -d $_ }
        Write-Host "  Deleted local merged branches."
    } else {
        Write-Host "  (dry run -- no branches deleted)"
    }
}

Write-Host ""
Write-Host "=== Remote merged branches ==="
$RemoteMerged = git branch -r --merged $MainBranch |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and $_ -notmatch "origin/(main|master|develop|staging|HEAD)" }

if (-not $RemoteMerged) {
    Write-Host "  No remote merged branches to clean."
} else {
    $RemoteMerged | ForEach-Object { Write-Host "  $_" }
    if (-not $DryRun) {
        $RemoteMerged | ForEach-Object {
            $Name = $_ -replace "^origin/", ""
            git push origin --delete $Name
        }
        Write-Host "  Deleted remote merged branches."
    } else {
        Write-Host "  (dry run -- no branches deleted)"
    }
}

Write-Host ""
Write-Host "Done. Run with -DryRun for a dry run: .\clean-merged-branches.ps1 main -DryRun"
