#!/usr/bin/env bash
set -euo pipefail

# Run SpotBugs static analysis on the project.
# Expects spotbugs-maven-plugin configured in pom.xml.

MVN="./mvnw"
[ -f "$MVN" ] || MVN="mvn"

echo "Running SpotBugs analysis..."
$MVN spotbugs:check -q 2>&1

EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
  echo "SpotBugs: PASSED (no bugs found)"
else
  echo "SpotBugs: FAILED (bugs found)"
  echo "Run './mvnw spotbugs:gui' to inspect findings in the GUI."
fi

exit $EXIT_CODE
