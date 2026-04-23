#!/bin/bash
set -e

MAIN_BRANCH="${1:-main}"
DRY_RUN="${2:-false}"

echo "Cleaning branches already merged into '$MAIN_BRANCH'..."

git fetch --prune origin

echo ""
echo "=== Local merged branches ==="
LOCAL_MERGED=$(git branch --merged "$MAIN_BRANCH" | grep -vE "^\*|^\s*(main|master|develop|staging)\s*$" || true)

if [ -z "$LOCAL_MERGED" ]; then
  echo "  No local merged branches to clean."
else
  echo "$LOCAL_MERGED"
  if [ "$DRY_RUN" = "false" ]; then
    echo "$LOCAL_MERGED" | xargs git branch -d
    echo "  Deleted local merged branches."
  else
    echo "  (dry run -- no branches deleted)"
  fi
fi

echo ""
echo "=== Remote merged branches ==="
REMOTE_MERGED=$(git branch -r --merged "$MAIN_BRANCH" | grep -vE "origin/(main|master|develop|staging|HEAD)" || true)

if [ -z "$REMOTE_MERGED" ]; then
  echo "  No remote merged branches to clean."
else
  echo "$REMOTE_MERGED"
  if [ "$DRY_RUN" = "false" ]; then
    echo "$REMOTE_MERGED" | sed 's|origin/||' | xargs -I{} git push origin --delete {}
    echo "  Deleted remote merged branches."
  else
    echo "  (dry run -- no branches deleted)"
  fi
fi

echo ""
echo "Done. Run with 'true' as second arg for dry run: ./clean-merged-branches.sh main true"
