#!/usr/bin/env bash
set -euo pipefail

# Audit Maven dependency tree and check for common issues.
# Usage: ./dependency-audit.sh [module]

MODULE="${1:-}"
MVN="./mvnw"
[ -f "$MVN" ] || MVN="mvn"

echo "=== Dependency Audit ==="

if [ -n "$MODULE" ]; then
  PL_FLAG="-pl $MODULE"
else
  PL_FLAG=""
fi

echo "1. Dependency tree:"
$MVN $PL_FLAG dependency:tree -q

echo ""
echo "2. Checking for dependency updates..."
$MVN $PL_FLAG versions:display-dependency-updates -q 2>/dev/null || echo "   (versions-maven-plugin not configured)"

echo ""
echo "3. Checking for unused/undeclared dependencies..."
$MVN $PL_FLAG dependency:analyze -q 2>/dev/null || echo "   (dependency analysis not available)"

echo ""
echo "4. Checking for duplicate dependencies..."
$MVN $PL_FLAG enforcer:enforce -q 2>/dev/null || echo "   (enforcer plugin not configured)"

echo ""
echo "Audit complete."
