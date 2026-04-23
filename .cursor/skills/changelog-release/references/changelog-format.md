# Changelog Format

Based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## Principles

- Changelogs are for humans, not machines
- Every version should have an entry
- Group changes by type (Added, Changed, Fixed, etc.)
- Most recent version comes first
- Each version has a release date in ISO format (YYYY-MM-DD)
- Follow semantic versioning

## Template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New features not yet released

## [1.1.0] - 2026-04-20

### Added
- User profile avatars
- Export data as CSV

### Changed
- Improved search performance by 40%

### Fixed
- Login redirect loop on mobile browsers

## [1.0.0] - 2026-04-01

### Added
- Initial release with core features

[Unreleased]: https://github.com/owner/repo/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/owner/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/owner/repo/releases/tag/v1.0.0
```

## Mapping Commits to Sections

| Commit Type | Changelog Section |
|-------------|-------------------|
| `feat` | Added |
| `fix` | Fixed |
| `perf` | Changed |
| `refactor` | Changed (if user-visible) |
| `BREAKING CHANGE` | Changed or Removed |
| `deprecate` | Deprecated |
| `security` / `fix(security)` | Security |
| `docs`, `test`, `ci`, `chore` | Omit (internal only) |

## Anti-Patterns

- Do not include every commit (skip internal chores, typo fixes)
- Do not use commit hashes as changelog entries
- Do not duplicate the git log
- Do not forget the `[Unreleased]` section for ongoing work
