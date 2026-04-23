#!/bin/bash
set -e

REPO="${1:-}"
BRANCH="${2:-main}"

if [ -z "$REPO" ]; then
  echo "Usage: setup-branch-protection.sh <owner/repo> [branch]"
  echo "  Example: setup-branch-protection.sh myorg/myrepo main"
  exit 1
fi

echo "Setting up branch protection for '$BRANCH' on '$REPO'..."

gh api "repos/$REPO/branches/$BRANCH/protection" \
  --method PUT \
  --input - <<'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["build"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_linear_history": true,
  "required_conversation_resolution": true
}
EOF

echo "Branch protection configured for '$BRANCH' on '$REPO'."
echo ""
echo "Verify with: gh api repos/$REPO/branches/$BRANCH/protection"
