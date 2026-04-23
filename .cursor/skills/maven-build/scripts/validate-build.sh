#!/usr/bin/env bash
set -euo pipefail

# Validate and compile a Maven project.
# Usage: ./validate-build.sh [module]

MODULE="${1:-}"
MVN="./mvnw"
[ -f "$MVN" ] || MVN="mvn"

echo "=== Maven Validation ==="

if [ -n "$MODULE" ]; then
  echo "Validating module: $MODULE"
  $MVN -pl "$MODULE" validate
  echo ""
  echo "Compiling module: $MODULE"
  $MVN -pl "$MODULE" compile
else
  echo "Validating project..."
  $MVN validate
  echo ""
  echo "Compiling project..."
  $MVN compile
fi

echo ""
echo "Validation and compilation successful."
