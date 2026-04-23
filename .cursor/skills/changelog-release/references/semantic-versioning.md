# Semantic Versioning

Based on [SemVer 2.0.0](https://semver.org/).

## Format

```
MAJOR.MINOR.PATCH[-prerelease][+build]
```

| Component | Meaning | Bump When |
|-----------|---------|-----------|
| MAJOR | Breaking changes | Incompatible API changes |
| MINOR | New features | Backwards-compatible additions |
| PATCH | Bug fixes | Backwards-compatible fixes |

## Rules

1. Once a version is released, the contents must not be modified
2. MAJOR version zero (`0.x.y`) is for initial development; anything may change
3. Version `1.0.0` defines the public API; all subsequent changes follow SemVer
4. PATCH increments for backwards-compatible bug fixes
5. MINOR increments for backwards-compatible new functionality (resets PATCH to 0)
6. MAJOR increments for backwards-incompatible changes (resets MINOR and PATCH to 0)

## Pre-Release Versions

```
2.0.0-alpha.1
2.0.0-beta.1
2.0.0-rc.1
```

Pre-release versions have lower precedence than the normal version.

## Examples

| Change | Before | After | Why |
|--------|--------|-------|-----|
| Fix null pointer bug | 1.2.3 | 1.2.4 | Backwards-compatible fix |
| Add new API endpoint | 1.2.4 | 1.3.0 | New feature, backwards-compatible |
| Remove deprecated endpoint | 1.3.0 | 2.0.0 | Breaking change |
| Add optional parameter | 2.0.0 | 2.1.0 | Additive, non-breaking |
| Change required parameter type | 2.1.0 | 3.0.0 | Breaking change |

## Version Precedence

```
1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-beta < 1.0.0-rc.1 < 1.0.0
```

## Automation with Conventional Commits

| Commit Type | SemVer Bump |
|-------------|-------------|
| `fix:` | PATCH |
| `feat:` | MINOR |
| `feat!:` or `BREAKING CHANGE:` footer | MAJOR |
| `docs:`, `test:`, `chore:` | No bump |
