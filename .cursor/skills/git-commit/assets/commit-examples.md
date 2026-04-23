# Commit Message Examples

## Good Examples

### Simple Fix
```
fix(api): Handle null response in user endpoint

The user API could return null for deleted accounts, causing a crash
in the dashboard. Add null check before accessing user properties.

Fixes #5678
```

### Feature with Scope
```
feat(alerts): Add Slack thread replies for alert updates

When an alert is updated or resolved, post a reply to the original
Slack thread instead of creating a new message. This keeps related
notifications grouped together.

Refs GH-1234
```

### Refactoring
```
refactor: Extract common validation logic to shared module

Move duplicate validation code from three endpoints into a shared
validator class. No behavior change.
```

### Breaking Change
```
feat(api)!: Remove deprecated v1 endpoints

Remove all v1 API endpoints that were deprecated in version 23.1.
Clients should migrate to v2 endpoints.

BREAKING CHANGE: v1 endpoints no longer available
Fixes #9999
```

### Documentation
```
docs: Add API authentication guide

Document the OAuth2 flow, token refresh process, and common
error codes for API consumers.
```

### Build/Dependencies
```
build(deps): Upgrade Spring Boot to 3.3.0

Upgrade from 3.2.x to 3.3.0 for virtual thread improvements
and security patches.
```

### Test
```
test(auth): Add login failure edge cases

Cover expired tokens, locked accounts, and rate limiting
in the authentication test suite.
```

### Revert
```
revert: feat(api): Add new endpoint

This reverts commit a1b2c3d4e5f6.

Reason: Caused performance regression in production.
```

## Bad Examples (and Fixes)

| Bad Message | Problem | Better Message |
|-------------|---------|----------------|
| `fix: stuff` | Vague | `fix(auth): Return 401 for expired tokens` |
| `WIP` | Not conventional format | `feat(cart): Add quantity validation (incomplete)` |
| `fix typo` | Missing type format | `docs: Fix typo in README installation steps` |
| `update code` | Meaningless | `refactor(api): Simplify error response builder` |
| `Fixed the bug` | Past tense, no type | `fix(db): Prevent connection leak on timeout` |
| `Changes` | Zero information | `feat(ui): Add dark mode toggle to settings` |
| `Addressing PR feedback` | Describes process, not change | `refactor(auth): Extract token validation to helper` |
