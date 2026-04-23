# Run the full test suite with JaCoCo coverage.
# Usage: .\run-tests.ps1 [module]

param([string]$Module = "")
$ErrorActionPreference = "Stop"

$Mvn = if (Test-Path ".\mvnw.cmd") { ".\mvnw.cmd" } elseif (Test-Path ".\mvnw") { ".\mvnw" } else { "mvn" }

if ($Module) {
    Write-Host "Running tests for module: $Module"
    & $Mvn -pl $Module clean verify "-Djacoco.skip=false"
} else {
    Write-Host "Running full test suite with coverage..."
    & $Mvn clean verify "-Djacoco.skip=false"
}

Write-Host ""
Write-Host "Test run complete. Check target\site\jacoco\index.html for coverage report."
