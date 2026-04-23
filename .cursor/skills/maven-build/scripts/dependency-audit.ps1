# Audit Maven dependency tree and check for common issues.
# Usage: .\dependency-audit.ps1 [module]

param([string]$Module = "")
$ErrorActionPreference = "Stop"

$Mvn = if (Test-Path ".\mvnw.cmd") { ".\mvnw.cmd" } elseif (Test-Path ".\mvnw") { ".\mvnw" } else { "mvn" }
$PlFlag = if ($Module) { @("-pl", $Module) } else { @() }

Write-Host "=== Dependency Audit ==="

Write-Host "1. Dependency tree:"
& $Mvn @PlFlag dependency:tree -q

Write-Host ""
Write-Host "2. Checking for dependency updates..."
try { & $Mvn @PlFlag versions:display-dependency-updates -q } catch { Write-Host "   (versions-maven-plugin not configured)" }

Write-Host ""
Write-Host "3. Checking for unused/undeclared dependencies..."
try { & $Mvn @PlFlag dependency:analyze -q } catch { Write-Host "   (dependency analysis not available)" }

Write-Host ""
Write-Host "4. Checking for duplicate dependencies..."
try { & $Mvn @PlFlag enforcer:enforce -q } catch { Write-Host "   (enforcer plugin not configured)" }

Write-Host ""
Write-Host "Audit complete."
