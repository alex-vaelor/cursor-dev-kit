#!/usr/bin/env bash
set -euo pipefail

# Start JFR profiling on a running JVM or launch with JFR enabled.
# Usage:
#   ./run-profiler.sh attach <PID> [duration_seconds]
#   ./run-profiler.sh start <main-class-or-jar> [jvm-args...]

MODE="${1:-help}"
DURATION="${3:-60}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="recording_${TIMESTAMP}.jfr"

case "$MODE" in
  attach)
    PID="${2:?PID required for attach mode}"
    echo "Attaching JFR to PID $PID for ${DURATION}s..."
    jcmd "$PID" JFR.start name=profile duration="${DURATION}s" filename="$OUTPUT_FILE" settings=profile
    echo "Recording will be saved to: $OUTPUT_FILE"
    echo "View with: jfr print --events jdk.ExecutionSample $OUTPUT_FILE"
    ;;
  start)
    TARGET="${2:?Main class or JAR required for start mode}"
    shift 2
    echo "Starting $TARGET with JFR profiling enabled..."
    java \
      -XX:StartFlightRecording=duration="${DURATION}s",filename="$OUTPUT_FILE",settings=profile \
      "$@" \
      -jar "$TARGET" 2>/dev/null || java \
      -XX:StartFlightRecording=duration="${DURATION}s",filename="$OUTPUT_FILE",settings=profile \
      "$@" \
      "$TARGET"
    echo "Recording saved to: $OUTPUT_FILE"
    ;;
  *)
    echo "JFR Profiler Helper"
    echo "Usage:"
    echo "  $0 attach <PID> [duration_seconds]  Attach to running JVM"
    echo "  $0 start <jar-or-class> [jvm-args]  Launch with JFR enabled"
    echo ""
    echo "Defaults: duration=60s"
    ;;
esac
