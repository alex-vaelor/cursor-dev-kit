#!/bin/bash
set -e

BRANCH="${1:-$(git rev-parse --abbrev-ref HEAD)}"
PATTERN="^(feature|bugfix|hotfix|release|chore|docs|refactor|test|experiment)\/[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]$"
SPECIAL_BRANCHES="^(main|master|develop|staging)$"

if [[ "$BRANCH" =~ $SPECIAL_BRANCHES ]]; then
  echo "OK: '$BRANCH' is a protected branch name."
  exit 0
fi

if [[ "$BRANCH" =~ $PATTERN ]]; then
  echo "OK: '$BRANCH' follows naming conventions."
  exit 0
else
  echo "ERROR: '$BRANCH' does not follow naming conventions."
  echo ""
  echo "Expected pattern: <type>/<ticket-id>-<description>"
  echo "  Types: feature, bugfix, hotfix, release, chore, docs, refactor, test, experiment"
  echo "  Use lowercase, hyphens only, no underscores or spaces."
  echo ""
  echo "Examples:"
  echo "  feature/AUTH-42-add-oauth-login"
  echo "  bugfix/API-99-fix-null-response"
  echo "  chore/update-dependencies"
  exit 1
fi
