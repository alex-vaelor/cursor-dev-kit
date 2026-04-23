# Generate and display JaCoCo coverage report summary.
# Assumes tests have already been run with JaCoCo enabled.

$ErrorActionPreference = "Stop"

$Mvn = if (Test-Path ".\mvnw.cmd") { ".\mvnw.cmd" } elseif (Test-Path ".\mvnw") { ".\mvnw" } else { "mvn" }

Write-Host "Generating JaCoCo coverage report..."
& $Mvn jacoco:report -q

$ReportDir = "target\site\jacoco"
if (Test-Path $ReportDir) {
    Write-Host "Coverage report generated at: $ReportDir\index.html"

    $XmlFile = Join-Path $ReportDir "jacoco.xml"
    if (Test-Path $XmlFile) {
        try {
            [xml]$Xml = Get-Content $XmlFile
            $InstrNode = $Xml.report.counter | Where-Object { $_.type -eq "INSTRUCTION" }
            if ($InstrNode) {
                $Covered = [int]$InstrNode.covered
                $Missed = [int]$InstrNode.missed
                $Total = $Covered + $Missed
                if ($Total -gt 0) {
                    $Pct = [math]::Floor($Covered * 100 / $Total)
                    Write-Host "Instruction coverage: ${Pct}% (${Covered}/${Total})"
                }
            }
        } catch {
            Write-Host "Could not parse coverage XML."
        }
    }
} else {
    Write-Host "No coverage report found. Run tests first: .\run-tests.ps1"
    exit 1
}
