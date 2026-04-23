# Branch Protection

## Recommended Settings for `main`

| Setting | Value | Reason |
|---------|-------|--------|
| Require pull request before merging | Yes | Prevent direct pushes |
| Required approving reviews | 1 | Ensure peer review |
| Dismiss stale reviews on push | Yes | Re-review after changes |
| Require status checks to pass | Yes | CI must pass |
| Require branches to be up to date | Yes | Prevent merge conflicts |
| Require conversation resolution | Yes | All feedback addressed |
| Do not allow force pushes | Yes | Protect history |
| Do not allow deletions | Yes | Prevent accidental deletion |

## Configuration via API

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --input - <<'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["build", "test", "lint"]
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
```

## View Current Protection

```bash
gh api repos/{owner}/{repo}/branches/main/protection --jq '{
  required_reviews: .required_pull_request_reviews.required_approving_review_count,
  status_checks: .required_status_checks.contexts,
  enforce_admins: .enforce_admins.enabled,
  linear_history: .required_linear_history.enabled
}'
```

## Remove Protection (Emergency)

```bash
gh api repos/{owner}/{repo}/branches/main/protection --method DELETE
```

Use only in emergencies. Re-apply immediately after the emergency fix.

## Rulesets (Newer Alternative)

GitHub rulesets offer more flexible protection. They can target multiple branches with patterns and support bypass lists.

```bash
gh api repos/{owner}/{repo}/rulesets --method POST --input - <<'EOF'
{
  "name": "main-protection",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": { "include": ["refs/heads/main"], "exclude": [] }
  },
  "rules": [
    { "type": "pull_request", "parameters": { "required_approving_review_count": 1 } },
    { "type": "required_status_checks", "parameters": { "required_status_checks": [{"context": "build"}] } }
  ]
}
EOF
```
