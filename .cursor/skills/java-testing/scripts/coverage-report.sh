#!/usr/bin/env bash
set -euo pipefail

# Generate and display JaCoCo coverage report summary.
# Assumes tests have already been run with JaCoCo enabled.

MVN="./mvnw"
[ -f "$MVN" ] || MVN="mvn"

echo "Generating JaCoCo coverage report..."
$MVN jacoco:report -q

REPORT_DIR="target/site/jacoco"
if [ -d "$REPORT_DIR" ]; then
  echo "Coverage report generated at: $REPORT_DIR/index.html"

  if command -v xmllint &>/dev/null && [ -f "$REPORT_DIR/jacoco.xml" ]; then
    INSTRUCTION=$(xmllint --xpath "string(//report/counter[@type='INSTRUCTION']/@covered)" "$REPORT_DIR/jacoco.xml" 2>/dev/null || echo "0")
    INSTRUCTION_MISSED=$(xmllint --xpath "string(//report/counter[@type='INSTRUCTION']/@missed)" "$REPORT_DIR/jacoco.xml" 2>/dev/null || echo "0")
    TOTAL=$((INSTRUCTION + INSTRUCTION_MISSED))
    if [ "$TOTAL" -gt 0 ]; then
      PCT=$((INSTRUCTION * 100 / TOTAL))
      echo "Instruction coverage: ${PCT}% (${INSTRUCTION}/${TOTAL})"
    fi
  fi
else
  echo "No coverage report found. Run tests first: ./run-tests.sh"
  exit 1
fi
