---
name: github-pr-review
description: "Use when creating pull requests, writing PR descriptions from diffs, reviewing PRs, enhancing PR quality, or managing the PR lifecycle. Covers PR creation, description generation, review dispatch, and feedback handling."
risk: safe
source: consolidated
version: "1.0.0"
metadata:
  category: workflow
  triggers: pull request, PR, create PR, review PR, PR description, write PR, improve PR, summarize changes, code review, PR review
  role: specialist
  scope: pull-request-lifecycle
  output-format: report
  related-skills: code-reviewer, git-commit, git-workflow
---

# GitHub PR Review

Manage the complete pull request lifecycle: create, describe, review, and merge.

## When to Use This Skill

- Creating a new pull request
- Writing or improving PR descriptions from diffs
- Requesting or dispatching code reviews
- Summarizing changes for reviewers
- Splitting large PRs into manageable pieces
- Adding review checklists and risk assessments

## PR Creation Workflow

1. **Ensure branch is ready** -- all commits pushed, CI passing, branch up to date with `main`
2. **Generate description** -- analyze the diff to produce a structured PR description
3. **Add context** -- link issue/ticket, explain motivation, note risks
4. **Create the PR** -- use `gh pr create` with the structured description
5. **Request review** -- assign reviewers or let CODEOWNERS auto-assign

### Quick PR Creation

```bash
BASE_SHA=$(git merge-base HEAD main)
gh pr create \
  --title "feat(auth): Add OAuth2 PKCE flow" \
  --body "$(cat <<'EOF'
## Summary
Add OAuth2 PKCE authentication flow for public clients.

## Changes
| Category | Files | Key Change |
|----------|-------|------------|
| source | `src/auth/oauth.ts` | PKCE flow implementation |
| test | `tests/auth/oauth.test.ts` | Token exchange tests |
| config | `.env.example` | New OAUTH_CLIENT_ID var |

## Testing
- Unit tests cover token exchange and error cases
- Manual testing against staging OAuth provider

## Risks & Rollback
- **Breaking?** No
- **Risk level:** Low -- new feature, no existing behavior changed
- **Rollback:** Revert this commit
EOF
)"
```

## PR Description Generation

When generating a PR description from a diff:

1. Run `git diff main...HEAD --stat` to identify changed files and scope
2. Categorize changes: source, test, config, docs, build, styles
3. Generate description using the template from `references/pr-description-guide.md`
4. Add review checklist items based on which categories changed
5. Flag breaking changes, security-sensitive files, or large diffs (>500 lines)

## Review Dispatch

To request a code review via subagent:

1. Get the commit range: `BASE_SHA=$(git merge-base HEAD main)` and `HEAD_SHA=$(git rev-parse HEAD)`
2. Dispatch a `code-reviewer` subagent with the commit range and PR context
3. Act on feedback: fix critical issues immediately, fix major issues before merging, note minor issues

## Splitting Large PRs

When diff exceeds 500 lines or 20 files:

1. Split by feature area or layer (API, service, data)
2. Split into preparatory refactoring + feature implementation
3. Use stacked PRs with dependency notes in descriptions
4. Mark generated or boilerplate code explicitly

## References

| Topic | File |
|-------|------|
| PR description guide | `references/pr-description-guide.md` |
| Review checklist | `references/review-checklist.md` |
| Review feedback guide | `references/review-feedback-guide.md` |
| PR size guidelines | `references/pr-size-guidelines.md` |
| PR enhancement guide | `references/pr-enhancement-guide.md` |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/pr-description-generator.sh` | Generate structured PR description from diff |

## Assets

| Asset | Purpose |
|-------|---------|
| `assets/review-report-template.md` | Standardized format for review reports |

## Limitations

- This skill covers PR lifecycle management. For deep code review analysis, use the `code-reviewer` skill.
- For GitHub Actions and CI/CD automation, use the `github-automation` skill.
- Stop and ask for clarification if the PR scope is unclear or requirements are ambiguous.
