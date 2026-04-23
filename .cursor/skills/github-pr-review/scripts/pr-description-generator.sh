#!/bin/bash
set -e

BASE="${1:-main}"
HEAD="${2:-HEAD}"

echo "## Summary"
echo "<!-- Describe what changed and why -->"
echo ""

echo "## Changes"
echo "| Category | Files | Key Change |"
echo "|----------|-------|------------|"

git diff "$BASE"..."$HEAD" --name-only | while read -r file; do
  case "$file" in
    src/main/java/*)       category="source" ;;
    src/test/*)            category="test" ;;
    src/main/resources/*)  category="config" ;;
    *.yml|*.yaml|*.properties) category="config" ;;
    pom.xml|.mvn/*)        category="build" ;;
    *.md|docs/*)           category="docs" ;;
    Dockerfile*|docker*|.github/*) category="build" ;;
    *migration*|*flyway*|*liquibase*) category="migration" ;;
    *)                     category="other" ;;
  esac
  echo "| $category | `` | <!-- describe --> |"
done

echo ""
echo "## Testing"
echo "- [ ] Unit tests pass (`./mvnw test`)"
echo "- [ ] Integration tests pass (`./mvnw verify -P integration`)"
echo "- [ ] Manual testing completed"
echo ""

LINES_CHANGED=$(git diff "$BASE"..."$HEAD" --stat | tail -1 | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || echo "0")
LINES_REMOVED=$(git diff "$BASE"..."$HEAD" --stat | tail -1 | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || echo "0")
TOTAL=$((LINES_CHANGED + LINES_REMOVED))

echo "## Risks & Rollback"
if [ "$TOTAL" -gt 500 ]; then
  echo "- **Risk level:** High -- $TOTAL lines changed. Consider splitting."
else
  echo "- **Risk level:** Low -- $TOTAL lines changed."
fi
echo "- **Breaking?** <!-- Yes / No -->"
echo "- **Rollback:** Revert this commit"
