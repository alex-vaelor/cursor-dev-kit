# Start JFR profiling on a running JVM or launch with JFR enabled.
# Usage:
#   .\run-profiler.ps1 attach <PID> [duration_seconds]
#   .\run-profiler.ps1 start <main-class-or-jar> [jvm-args...]

param(
    [Parameter(Position = 0)][string]$Mode = "help",
    [Parameter(Position = 1)][string]$Target = "",
    [Parameter(Position = 2)][int]$Duration = 60,
    [Parameter(ValueFromRemainingArguments)][string[]]$ExtraArgs
)
$ErrorActionPreference = "Stop"

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputFile = "recording_${Timestamp}.jfr"

switch ($Mode) {
    "attach" {
        if (-not $Target) { Write-Error "PID required for attach mode"; exit 1 }
        Write-Host "Attaching JFR to PID $Target for ${Duration}s..."
        jcmd $Target JFR.start name=profile duration="${Duration}s" filename="$OutputFile" settings=profile
        Write-Host "Recording will be saved to: $OutputFile"
        Write-Host "View with: jfr print --events jdk.ExecutionSample $OutputFile"
    }
    "start" {
        if (-not $Target) { Write-Error "Main class or JAR required for start mode"; exit 1 }
        Write-Host "Starting $Target with JFR profiling enabled..."
        $JfrArg = "-XX:StartFlightRecording=duration=${Duration}s,filename=$OutputFile,settings=profile"
        if ($Target -match '\.jar$') {
            java $JfrArg @ExtraArgs -jar $Target
        } else {
            java $JfrArg @ExtraArgs $Target
        }
        Write-Host "Recording saved to: $OutputFile"
    }
    default {
        Write-Host "JFR Profiler Helper"
        Write-Host "Usage:"
        Write-Host "  .\run-profiler.ps1 attach <PID> [duration_seconds]  Attach to running JVM"
        Write-Host "  .\run-profiler.ps1 start <jar-or-class> [jvm-args]  Launch with JFR enabled"
        Write-Host ""
        Write-Host "Defaults: duration=60s"
    }
}
