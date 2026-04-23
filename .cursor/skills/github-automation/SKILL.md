---
name: github-automation
description: "Use when setting up GitHub Actions workflows, configuring branch protection, creating CI/CD pipelines, managing CODEOWNERS, or automating GitHub repository operations. Covers Actions patterns, reusable workflows, and repository configuration."
risk: critical
source: consolidated
version: "1.0.0"
metadata:
  category: automation
  triggers: github actions, CI/CD, workflow, branch protection, CODEOWNERS, automation, github action, pipeline, continuous integration
  role: specialist
  scope: github-repository-automation
  related-skills: git-workflow, github-pr-review, changelog-release
---

# GitHub Automation

Set up and manage GitHub Actions workflows, branch protection, CODEOWNERS, and repository automation.

## When to Use This Skill

- Creating or modifying GitHub Actions workflows
- Setting up CI/CD pipelines
- Configuring branch protection rules
- Setting up CODEOWNERS for automatic reviewer assignment
- Automating issue triage, PR labeling, or stale issue management
- Creating reusable workflow templates

## When Not to Use

- Manual Git operations (use `git-workflow`)
- Writing PR descriptions (use `github-pr-review`)
- Commit conventions (use `git-commit`)

## GitHub Actions Quick Start

### Workflow Structure

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build and test
        run: ./mvnw verify
```

### Key Practices

- Pin actions to full SHA for security, not just major version
- Use `concurrency` to cancel superseded runs
- Cache dependencies to speed up builds
- Use matrix builds for multi-version testing
- Set minimum `GITHUB_TOKEN` permissions
- Never put secrets in workflow files

## Workflow Templates

Ready-to-use templates are available in `assets/workflow-templates/`:

| Template | Purpose |
|----------|---------|
| `ci-java.yml` | Java build + test with Maven |
| `pr-checks.yml` | PR validation (lint, format, test) |
| `release.yml` | Automated release with changelog |

## Branch Protection Setup

Configure via `gh` CLI:

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["build","test"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

## CODEOWNERS

Place `.github/CODEOWNERS` to auto-assign reviewers per path. See `references/codeowners-guide.md`.

## References

| Topic | File |
|-------|------|
| Actions patterns | `references/actions-patterns.md` |
| Branch protection | `references/branch-protection.md` |
| CODEOWNERS guide | `references/codeowners-guide.md` |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/setup-branch-protection.sh` | Configure branch protection via API |

## Limitations

- Workflow changes require push to `.github/workflows/` -- test on a branch first.
- Branch protection API requires admin access.
- Stop and ask for clarification if the target CI/CD environment or deployment targets are unknown.
