#!/bin/bash
set -e

MSG_FILE="${1:-}"
if [ -z "$MSG_FILE" ]; then
  echo "Usage: check-commit-message.sh <commit-message-file>"
  echo "  Typically called as a commit-msg hook with .git/COMMIT_EDITMSG"
  exit 1
fi

MSG=$(head -1 "$MSG_FILE")
PATTERN="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9\-]+\))?(!)?: [A-Z].{1,70}$"

if [[ "$MSG" =~ $PATTERN ]]; then
  echo "OK: Commit message follows conventional format."
  exit 0
else
  echo "ERROR: Commit message does not follow conventional format."
  echo ""
  echo "Expected: <type>(<optional-scope>): <Subject starting with capital>"
  echo "  Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert"
  echo "  Subject must start with a capital letter and be <= 72 characters."
  echo ""
  echo "Got: $MSG"
  echo ""
  echo "Examples:"
  echo "  feat(auth): Add OAuth2 PKCE flow"
  echo "  fix: Handle null response in user endpoint"
  echo "  docs: Update API usage guide"
  exit 1
fi
