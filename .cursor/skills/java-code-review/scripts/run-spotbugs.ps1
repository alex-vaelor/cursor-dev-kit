# Run SpotBugs static analysis on the project.
# Expects spotbugs-maven-plugin configured in pom.xml.

$ErrorActionPreference = "Continue"

$Mvn = if (Test-Path ".\mvnw.cmd") { ".\mvnw.cmd" } elseif (Test-Path ".\mvnw") { ".\mvnw" } else { "mvn" }

Write-Host "Running SpotBugs analysis..."
& $Mvn spotbugs:check -q 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "SpotBugs: PASSED (no bugs found)"
} else {
    Write-Host "SpotBugs: FAILED (bugs found)"
    Write-Host "Run '.\mvnw.cmd spotbugs:gui' to inspect findings in the GUI."
}

exit $LASTEXITCODE
