# CODEOWNERS Guide

## Overview

The CODEOWNERS file auto-assigns reviewers when PRs touch specific paths. Place it at `.github/CODEOWNERS`, `CODEOWNERS`, or `docs/CODEOWNERS`.

## Syntax

```
# Each line: pattern    owner(s)
# Owners can be @username, @org/team, or email

# Default owner for everything
*                       @team-lead

# Specific directories
/src/auth/              @security-team
/src/api/               @backend-team @api-lead
/src/ui/                @frontend-team
/docs/                  @docs-team
/infra/                 @platform-team

# Specific file types
*.sql                   @dba-team
*.proto                 @api-team
Dockerfile              @devops-team
docker-compose*.yml     @devops-team

# CI/CD configuration
/.github/               @devops-team
/.github/workflows/     @devops-team @team-lead

# Build configuration
pom.xml                 @build-team
build.gradle*           @build-team

# Security-sensitive files
**/security/**          @security-team
**/auth/**              @security-team
**/crypto/**            @security-team
```

## Rules

- Later rules override earlier ones (last match wins)
- A PR requires approval from at least one owner of each matched rule
- If no CODEOWNERS rule matches, the PR has no required owner reviews
- CODEOWNERS requires branch protection with "Require review from Code Owners" enabled

## Pattern Syntax

| Pattern | Matches |
|---------|---------|
| `*` | Everything |
| `*.js` | All .js files |
| `/docs/` | Only the root docs/ directory |
| `docs/` | Any docs/ directory at any depth |
| `/src/auth/` | Only root src/auth/ |
| `**/auth/**` | Any auth/ directory at any depth |

## Best Practices

- Keep ownership granular -- avoid a single owner for `*`
- Use team handles (`@org/team`) instead of individual usernames
- Review and update CODEOWNERS when team structure changes
- Combine with branch protection for enforcement
- Do not assign too many owners per path (slows down review assignment)

## Verifying CODEOWNERS

```bash
# Check who would be assigned for a specific file
gh api repos/{owner}/{repo}/codeowners/errors
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using Windows paths (`\`) | Use forward slashes (`/`) |
| Referencing non-existent teams | Verify team exists in org |
| Missing leading `/` for root paths | Add `/` to anchor to repo root |
| Overly broad patterns | Be specific to reduce reviewer fatigue |
