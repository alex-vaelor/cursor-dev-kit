# Run Checkstyle analysis on the project.
# Expects maven-checkstyle-plugin configured in pom.xml.

$ErrorActionPreference = "Continue"

$Mvn = if (Test-Path ".\mvnw.cmd") { ".\mvnw.cmd" } elseif (Test-Path ".\mvnw") { ".\mvnw" } else { "mvn" }

Write-Host "Running Checkstyle analysis..."
& $Mvn checkstyle:check -q 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "Checkstyle: PASSED (no violations)"
} else {
    Write-Host "Checkstyle: FAILED (violations found)"
    Write-Host "Check target\checkstyle-result.xml for details."
}

exit $LASTEXITCODE
