#!/usr/bin/env bash
set -euo pipefail

# Run Checkstyle analysis on the project.
# Expects maven-checkstyle-plugin configured in pom.xml.

MVN="./mvnw"
[ -f "$MVN" ] || MVN="mvn"

echo "Running Checkstyle analysis..."
$MVN checkstyle:check -q 2>&1

EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
  echo "Checkstyle: PASSED (no violations)"
else
  echo "Checkstyle: FAILED (violations found)"
  echo "Check target/checkstyle-result.xml for details."
fi

exit $EXIT_CODE
