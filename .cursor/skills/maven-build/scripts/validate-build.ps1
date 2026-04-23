# Validate and compile a Maven project.
# Usage: .\validate-build.ps1 [module]

param([string]$Module = "")
$ErrorActionPreference = "Stop"

$Mvn = if (Test-Path ".\mvnw.cmd") { ".\mvnw.cmd" } elseif (Test-Path ".\mvnw") { ".\mvnw" } else { "mvn" }

Write-Host "=== Maven Validation ==="

if ($Module) {
    Write-Host "Validating module: $Module"
    & $Mvn -pl $Module validate
    Write-Host ""
    Write-Host "Compiling module: $Module"
    & $Mvn -pl $Module compile
} else {
    Write-Host "Validating project..."
    & $Mvn validate
    Write-Host ""
    Write-Host "Compiling project..."
    & $Mvn compile
}

Write-Host ""
Write-Host "Validation and compilation successful."
