#!/usr/bin/env bash
set -euo pipefail

# Run the full test suite with JaCoCo coverage.
# Usage: ./run-tests.sh [module]
#   module  optional Maven module name to test (e.g. "core", "api")

MODULE="${1:-}"
MVN="./mvnw"
[ -f "$MVN" ] || MVN="mvn"

if [ -n "$MODULE" ]; then
  echo "Running tests for module: $MODULE"
  $MVN -pl "$MODULE" clean verify -Djacoco.skip=false
else
  echo "Running full test suite with coverage..."
  $MVN clean verify -Djacoco.skip=false
fi

echo ""
echo "Test run complete. Check target/site/jacoco/index.html for coverage report."
