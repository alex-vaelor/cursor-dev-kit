#!/bin/bash
set -e

MESSAGE="${1:-}"
if [ -z "$MESSAGE" ]; then
  echo "Usage: smart-commit.sh '<commit-message>'"
  echo "  Example: smart-commit.sh 'feat(auth): Add OAuth2 login'"
  exit 1
fi

PATTERN="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9\-]+\))?(!)?: [A-Z].{1,70}$"
HEADER=$(echo "$MESSAGE" | head -1)

if ! [[ "$HEADER" =~ $PATTERN ]]; then
  echo "ERROR: Commit message does not follow conventional format."
  echo "Expected: <type>(<scope>): <Subject>"
  echo "Got: $HEADER"
  exit 1
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "ERROR: Cannot commit directly to '$BRANCH'. Create a feature branch first."
  exit 1
fi

if [ -z "$(git diff --cached --name-only)" ]; then
  echo "No staged changes. Staging all tracked changes..."
  git add -u
fi

if [ -z "$(git diff --cached --name-only)" ]; then
  echo "ERROR: No changes to commit."
  exit 1
fi

git commit --trailer "Made-with: Cursor" -m "$MESSAGE"
echo ""
echo "Committed to '$BRANCH'. Push with: git push -u origin $BRANCH"
