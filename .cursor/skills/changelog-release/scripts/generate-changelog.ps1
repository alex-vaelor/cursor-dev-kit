# Generate a changelog draft from conventional commits since the last tag.
# Usage: .\generate-changelog.ps1 [last_tag] [output_file]

param(
    [string]$LastTag = "",
    [string]$Output = "CHANGELOG-DRAFT.md"
)
$ErrorActionPreference = "Stop"

if (-not $LastTag) {
    $LastTag = git describe --tags --abbrev=0 2>$null
}

if ($LastTag) {
    Write-Host "Generating changelog since $LastTag..."
    $Range = "$LastTag..HEAD"
} else {
    Write-Host "No previous tag found. Generating changelog from all commits."
    $Range = ""
}

$RangeArgs = if ($Range) { @($Range) } else { @() }

function Get-CommitsByType([string]$Prefix) {
    $Logs = git log @RangeArgs --pretty=format:"%s" --no-merges 2>$null
    if (-not $Logs) { return @() }
    $Logs | Where-Object { $_ -match "^$Prefix" } | ForEach-Object { ($_ -replace "^${Prefix}[^:]*:\s*", "- ") }
}

$Lines = @()
$Lines += "## [Unreleased]"
$Lines += ""

$Feat = Get-CommitsByType "feat"
if ($Feat) { $Lines += "### Added"; $Lines += $Feat; $Lines += "" }

$Fix = Get-CommitsByType "fix"
if ($Fix) { $Lines += "### Fixed"; $Lines += $Fix; $Lines += "" }

$Perf = Get-CommitsByType "perf"
$Refactor = Get-CommitsByType "refactor"
$Changed = @($Perf) + @($Refactor) | Where-Object { $_ }
if ($Changed) { $Lines += "### Changed"; $Lines += $Changed; $Lines += "" }

$Breaking = git log @RangeArgs --pretty=format:"%B" --no-merges 2>$null |
    Where-Object { $_ -match "^BREAKING CHANGE:" } |
    ForEach-Object { ($_ -replace "^BREAKING CHANGE:\s*", "- **BREAKING**: ") }
if ($Breaking) { $Lines += "### Breaking Changes"; $Lines += $Breaking; $Lines += "" }

$Lines | Out-File -FilePath $Output -Encoding utf8
Write-Host "Changelog draft written to $Output"
