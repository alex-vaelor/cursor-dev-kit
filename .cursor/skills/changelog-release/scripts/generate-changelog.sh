#!/bin/bash
set -e

LAST_TAG="${1:-$(git describe --tags --abbrev=0 2>/dev/null || echo "")}"
OUTPUT="${2:-CHANGELOG-DRAFT.md}"

if [ -z "$LAST_TAG" ]; then
  echo "No previous tag found. Generating changelog from all commits."
  RANGE=""
else
  echo "Generating changelog since $LAST_TAG..."
  RANGE="$LAST_TAG..HEAD"
fi

{
  echo "## [Unreleased]"
  echo ""

  FEAT=$(git log $RANGE --pretty=format:"%s" --no-merges | grep -E "^feat" | sed 's/^feat[^:]*: /- /' || true)
  if [ -n "$FEAT" ]; then
    echo "### Added"
    echo "$FEAT"
    echo ""
  fi

  FIX=$(git log $RANGE --pretty=format:"%s" --no-merges | grep -E "^fix" | sed 's/^fix[^:]*: /- /' || true)
  if [ -n "$FIX" ]; then
    echo "### Fixed"
    echo "$FIX"
    echo ""
  fi

  PERF=$(git log $RANGE --pretty=format:"%s" --no-merges | grep -E "^perf" | sed 's/^perf[^:]*: /- /' || true)
  REFACTOR=$(git log $RANGE --pretty=format:"%s" --no-merges | grep -E "^refactor" | sed 's/^refactor[^:]*: /- /' || true)
  CHANGED="$PERF$REFACTOR"
  if [ -n "$CHANGED" ]; then
    echo "### Changed"
    echo "$CHANGED"
    echo ""
  fi

  BREAKING=$(git log $RANGE --pretty=format:"%B" --no-merges | grep -E "^BREAKING CHANGE:" | sed 's/^BREAKING CHANGE: /- **BREAKING**: /' || true)
  if [ -n "$BREAKING" ]; then
    echo "### Breaking Changes"
    echo "$BREAKING"
    echo ""
  fi
} > "$OUTPUT"

echo "Changelog draft written to $OUTPUT"
