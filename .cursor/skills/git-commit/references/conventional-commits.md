# Conventional Commits Specification

Based on the [Conventional Commits 1.0.0](https://www.conventionalcommits.org/) specification.

## Structure

```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

## Type Reference

| Type | SemVer Impact | Description |
|------|---------------|-------------|
| `feat` | MINOR | A new feature visible to the user |
| `fix` | PATCH | A bug fix |
| `docs` | -- | Documentation changes only |
| `style` | -- | Formatting, whitespace, semicolons (no logic change) |
| `refactor` | -- | Code restructuring without behavior change |
| `perf` | PATCH | Performance improvement |
| `test` | -- | Adding or correcting tests |
| `build` | -- | Build system, dependencies, toolchain |
| `ci` | -- | CI/CD configuration changes |
| `chore` | -- | Maintenance, tooling, config |
| `revert` | varies | Reverting a previous commit |

## Breaking Changes

Signal breaking changes with `!` after the type/scope and a `BREAKING CHANGE:` footer:

```
feat(api)!: Remove deprecated v1 endpoints

Remove all v1 API endpoints deprecated in version 23.1.
Clients must migrate to v2 before upgrading.

BREAKING CHANGE: v1 endpoints no longer available
```

Breaking changes trigger a MAJOR version bump in SemVer.

## Scope

Scope is optional and indicates the area of the codebase affected:

```
feat(auth): Add OAuth2 PKCE flow
fix(api): Handle null in user response
test(cart): Add quantity overflow edge case
build(deps): Upgrade Spring Boot to 3.3
```

Common scopes: `auth`, `api`, `db`, `ui`, `config`, `deps`, `ci`, module names.

## Footer Conventions

### Issue References
```
Fixes #1234           # Closes GitHub issue
Fixes GH-1234         # Closes GitHub issue (explicit)
Refs LINEAR-ABC-123   # Links without closing
Closes JIRA-567       # Closes Jira ticket
```

### Co-Authorship
```
Co-Authored-By: Name <email@example.com>
```

### Multiple Footers
```
feat(auth): Add SSO support

Implement SAML-based SSO for enterprise customers.

Fixes #789
Refs ARCH-42
Co-Authored-By: Alice <alice@example.com>
```

## Examples

### Minimal
```
fix: Prevent crash on empty input
```

### With Scope and Body
```
feat(auth): Add multi-factor authentication

Add TOTP-based MFA as an optional security layer.
Users can enable MFA from their security settings.
The implementation uses RFC 6238 for token generation.

Fixes #234
```

### Revert
```
revert: feat(api): Add new endpoint

This reverts commit a1b2c3d4e5f6.

Reason: Caused performance regression in production.
```

## Validation Regex

For the header line:

```regex
^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9\-]+\))?(!)?: [A-Z].{1,70}$
```
