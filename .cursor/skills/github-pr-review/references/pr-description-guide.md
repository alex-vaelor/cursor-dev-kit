# PR Description Guide

## Template

```markdown
## Summary
<!-- One paragraph: what changed and why. Link to issue/ticket. -->

## Changes
| Category | Files | Key Change |
|----------|-------|------------|
| source | `AuthService.java` | Added OAuth2 PKCE flow |
| test | `AuthServiceTest.java` | Covers token refresh edge case |
| config | `application.yml` | New `spring.security.oauth2.client` properties |

## Why
<!-- Link to issue + one sentence on motivation -->

## Testing
- [ ] Unit tests pass (`./mvnw test`)
- [ ] Integration tests pass (`./mvnw verify -P integration`)
- [ ] Manual testing on staging
- [ ] No coverage regression

## Risks & Rollback
- **Breaking?** Yes / No
- **Rollback**: Revert this commit; no migration needed
- **Risk level**: Low / Medium / High -- because ___

## Checklist
- [ ] Self-reviewed the diff
- [ ] Tests added for new behavior
- [ ] Javadoc updated (if public API changed)
- [ ] No secrets in the diff
- [ ] No debug statements left in (`System.out.println`, `e.printStackTrace()`)
```

## Writing Effective Summaries

- Start with what the PR does, then why
- Link to the issue or ticket
- Mention any design decisions or trade-offs
- Call out anything unusual or risky

### Good Summary
> Add OAuth2 PKCE authentication for public clients using Spring Security. This replaces the implicit flow which is being deprecated. Uses `authorization_code` grant with PKCE challenge per RFC 7636. Fixes #234.

### Bad Summary
> Updated auth code.

## Change Categories

| Category | When to Use |
|----------|-------------|
| `source` | Application code changes (Java, Kotlin) |
| `test` | Test additions or modifications |
| `config` | Configuration (`application.yml`, `pom.xml`) |
| `docs` | Documentation changes |
| `build` | Build scripts, CI, Maven plugins |
| `migration` | Flyway/Liquibase database migrations |
| `infra` | Infrastructure, deployment, Docker changes |

## Review Checklist by Category

Add checklist sections only when the matching file category appears in the diff:

| File Category | Checklist Items |
|---------------|-----------------|
| source | No debug statements; methods < 30 lines; descriptive names; proper exception handling |
| test | Meaningful assertions; edge cases; no flaky tests; AAA/GWT pattern |
| config | No hardcoded secrets; properties documented; backwards compatible |
| docs | Accurate; Javadoc examples included; changelog updated |
| security-sensitive | Input validation; no secrets in logs; authorization checks correct |
| migration | Reversible; tested on staging; no data loss; `@Rollback` tested |
