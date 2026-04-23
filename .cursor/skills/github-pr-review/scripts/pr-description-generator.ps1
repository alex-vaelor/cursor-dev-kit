# Generate a structured PR description from the diff between two branches.
# Usage: .\pr-description-generator.ps1 [base_branch] [head_ref]

param(
    [string]$Base = "main",
    [string]$Head = "HEAD"
)
$ErrorActionPreference = "Stop"

Write-Output "## Summary"
Write-Output "<!-- Describe what changed and why -->"
Write-Output ""

Write-Output "## Changes"
Write-Output "| Category | Files | Key Change |"
Write-Output "|----------|-------|------------|"

$Files = git diff "$Base...$Head" --name-only
foreach ($File in $Files) {
    if (-not $File) { continue }
    $Category = switch -Wildcard ($File) {
        "src/main/java/*"       { "source" }
        "src/test/*"            { "test" }
        "src/main/resources/*"  { "config" }
        "*.yml"                 { "config" }
        "*.yaml"                { "config" }
        "*.properties"          { "config" }
        "pom.xml"               { "build" }
        ".mvn/*"                { "build" }
        "*.md"                  { "docs" }
        "docs/*"                { "docs" }
        "Dockerfile*"           { "build" }
        "docker*"               { "build" }
        ".github/*"             { "build" }
        "*migration*"           { "migration" }
        "*flyway*"              { "migration" }
        "*liquibase*"           { "migration" }
        default                 { "other" }
    }
    Write-Output "| $Category | ``$File`` | <!-- describe --> |"
}

Write-Output ""
Write-Output "## Testing"
Write-Output "- [ ] Unit tests pass (``.\mvnw.cmd test``)"
Write-Output "- [ ] Integration tests pass (``.\mvnw.cmd verify -P integration``)"
Write-Output "- [ ] Manual testing completed"
Write-Output ""

$StatLine = (git diff "$Base...$Head" --stat | Select-Object -Last 1)
$LinesChanged = 0; $LinesRemoved = 0
if ($StatLine -match '(\d+) insertion') { $LinesChanged = [int]$Matches[1] }
if ($StatLine -match '(\d+) deletion')  { $LinesRemoved = [int]$Matches[1] }
$Total = $LinesChanged + $LinesRemoved

Write-Output "## Risks & Rollback"
if ($Total -gt 500) {
    Write-Output "- **Risk level:** High -- $Total lines changed. Consider splitting."
} else {
    Write-Output "- **Risk level:** Low -- $Total lines changed."
}
Write-Output "- **Breaking?** <!-- Yes / No -->"
Write-Output "- **Rollback:** Revert this commit"
