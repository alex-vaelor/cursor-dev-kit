---
name: Java Pull Request
about: Pull request template for Java/Spring Boot projects
---

## Summary

<!-- One paragraph: what changed and why -->

## Changes

| Category | Files | Key Change |
|----------|-------|------------|
| Feature | | |
| Refactor | | |
| Test | | |
| Config | | |

## Testing

- [ ] Unit tests added/updated for new behavior
- [ ] Integration tests added/updated where applicable
- [ ] All tests pass: `./mvnw clean verify`
- [ ] Coverage meets quality gates (>= 80% line, >= 70% branch)

## Quality Checks

- [ ] Code compiles without warnings
- [ ] Checkstyle passes (no violations)
- [ ] SpotBugs passes (no HIGH/CRITICAL findings)
- [ ] No new TODO/FIXME without linked issue
- [ ] No secrets or credentials committed

## Java-Specific Checklist

- [ ] Constructor injection only (no field injection)
- [ ] Records used for DTOs and value objects where appropriate
- [ ] Exceptions are specific, not generic `Exception`
- [ ] Try-with-resources for all `AutoCloseable`
- [ ] No wildcard imports
- [ ] JSpecify null-safety annotations where applicable
- [ ] `jakarta.*` namespace (not `javax.*`)

## Spring-Specific Checklist (if applicable)

- [ ] Correct stereotype annotations (`@RestController`, `@Service`, `@Repository`)
- [ ] `@Transactional` on service methods, not repositories
- [ ] Error handling via `@ControllerAdvice` / Problem Details
- [ ] `@ConfigurationProperties` with `@Validated` for new config

## Risks

<!-- Breaking changes, risk level (low/medium/high), rollback plan -->

## Related Issues

<!-- Fixes #N, Relates to #M -->
