---
name: changelog-release
description: "Use when generating changelogs, managing releases, bumping versions, creating release tags, or automating the release pipeline. Covers Keep a Changelog format, semantic versioning, and release automation."
risk: safe
source: consolidated
version: "1.0.0"
metadata:
  category: workflow
  triggers: changelog, release, version bump, semantic versioning, release notes, tag, publish
  role: specialist
  scope: release-management
  related-skills: git-commit, github-automation, git-workflow
---

# Changelog and Release Management

Automate changelog generation, semantic versioning, and the release pipeline.

## When to Use This Skill

- Generating a changelog from commit history
- Creating a new release (tag, notes, artifacts)
- Bumping version numbers following SemVer
- Setting up automated release workflows
- Writing release notes for stakeholders

## Changelog Format

Follow [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- OAuth2 PKCE authentication flow

### Fixed
- Null pointer in user endpoint for deleted accounts

## [2.4.1] - 2026-04-20

### Fixed
- Connection leak under high concurrency

### Changed
- Upgraded Spring Boot to 3.3.0

## [2.4.0] - 2026-04-15

### Added
- Multi-factor authentication support
- Slack notification integration

### Deprecated
- v1 API endpoints (removal in 3.0.0)
```

### Section Types

| Section | When to Use |
|---------|-------------|
| Added | New features |
| Changed | Changes to existing functionality |
| Deprecated | Features to be removed in future |
| Removed | Features removed in this release |
| Fixed | Bug fixes |
| Security | Vulnerability fixes |

## Version Bumping (SemVer)

```
MAJOR.MINOR.PATCH

MAJOR: Breaking changes (incompatible API changes)
MINOR: New features (backwards compatible)
PATCH: Bug fixes (backwards compatible)
```

### Decision Table

| Change Type | Version Bump | Example |
|-------------|-------------|---------|
| Breaking API change | MAJOR | `feat(api)!: Remove v1 endpoints` |
| New feature | MINOR | `feat(auth): Add MFA support` |
| Bug fix | PATCH | `fix(db): Prevent connection leak` |
| Docs, tests, chore | No bump | `docs: Update README` |

## Release Workflow

1. **Prepare** -- update changelog, bump version in `pom.xml`
2. **Commit** -- `chore(release): Prepare v2.5.0`
3. **Tag** -- `git tag -a v2.5.0 -m "Release 2.5.0"`
4. **Push** -- `git push origin main --tags`
5. **Publish** -- GitHub Release with changelog body and artifacts

### Quick Release Command

```bash
VERSION="2.5.0"
git tag -a "v$VERSION" -m "Release $VERSION"
git push origin "v$VERSION"
gh release create "v$VERSION" \
  --title "v$VERSION" \
  --notes-file CHANGELOG.md \
  target/*.jar
```

## References

| Topic | File |
|-------|------|
| Changelog format | `references/changelog-format.md` |
| Semantic versioning | `references/semantic-versioning.md` |
| Release workflow | `references/release-workflow.md` |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/generate-changelog.sh` | Generate changelog from conventional commits |

## Limitations

- Changelog generation depends on clean conventional commit messages.
- SemVer bump detection requires commit type analysis.
- Stop and ask for clarification if the release scope or version strategy is unclear.
