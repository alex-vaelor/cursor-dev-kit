# PR Enhancement Guide

## Purpose

Improve pull request quality through structured descriptions, risk assessment, split strategies, and reviewer guidance. High-quality PRs lead to faster, more effective reviews.

## PR Description Generation from Diffs

### Step-by-Step Process

1. **Gather diff data**
   ```bash
   BASE_SHA=$(git merge-base HEAD main)
   git diff $BASE_SHA...HEAD --stat
   git log $BASE_SHA...HEAD --oneline
   ```

2. **Categorize changes**

   | Category | Pattern | Example |
   |----------|---------|---------|
   | source | `src/main/java/**` | Business logic, services, controllers |
   | test | `src/test/java/**` | Unit, integration, acceptance tests |
   | config | `*.yml`, `*.properties`, `*.xml` | Application/build config |
   | migration | `db/migration/**`, `*.sql` | Flyway migrations |
   | docs | `*.md`, `docs/**` | Documentation |
   | build | `pom.xml`, `build.gradle` | Build configuration |
   | infra | `Dockerfile`, `docker-compose.yml`, `.github/**` | Infrastructure |

3. **Generate structured description**
   ```markdown
   ## Summary
   [1-3 sentences: what and why]

   ## Changes
   | Category | Files | Key Change |
   |----------|-------|------------|
   | source | `OrderService.java` | Add retry logic for payment processing |
   | test | `OrderServiceTest.java` | Test retry behavior and failure cases |
   | config | `application.yml` | Add retry configuration properties |

   ## Testing
   - Unit tests for OrderService retry logic
   - Integration test with WireMock for payment gateway failures
   - Manual testing against staging environment

   ## Risks & Rollback
   - **Breaking?** No
   - **Risk level:** Medium -- changes payment flow
   - **Rollback:** Revert commit; no data migration needed

   ## Review Guidance
   - Focus on: retry configuration and idempotency handling
   - Note: OrderService.java lines 45-80 contain the core logic
   ```

## Risk Assessment Framework

### Risk Scoring

| Factor | Low (1) | Medium (2) | High (3) |
|--------|---------|------------|----------|
| **Scope** | <100 lines, 1-3 files | 100-400 lines, 3-10 files | >400 lines, 10+ files |
| **Impact** | No behavior change | Internal behavior change | User-facing or data change |
| **Reversibility** | Simple revert | Revert + minor fixup | Data migration needed |
| **Blast radius** | Single feature | Module/service | Cross-service or DB schema |
| **Test coverage** | >90% of changes tested | 60-90% tested | <60% tested |

**Overall risk = highest individual factor** (not average)

### Risk Mitigation Checklist

- [ ] Feature flag wrapping new behavior?
- [ ] Backward-compatible DB migration (expand-contract)?
- [ ] Rollback steps documented?
- [ ] Monitoring/alerting in place for the affected area?
- [ ] Canary deployment possible?

## Split Strategies for Large PRs

### When to Split
- Diff exceeds 400 lines of meaningful code
- Changes span 3+ unrelated modules
- Mix of refactoring and feature work
- Reviewer feedback says "this is too large"

### Split Patterns

| Pattern | When to Use | Example |
|---------|-------------|---------|
| **Layer split** | Changes span API + service + data layers | PR1: data layer; PR2: service; PR3: API |
| **Refactor-then-feature** | Existing code needs cleanup first | PR1: extract interface; PR2: new implementation |
| **Config-then-code** | Infrastructure changes needed first | PR1: add dependency + config; PR2: use it |
| **Test-first** | Adding tests for existing untested code | PR1: add tests; PR2: refactor with safety net |
| **Feature-flag-split** | Large feature that can be deployed incrementally | PR1: flag + skeleton; PR2-N: implementations behind flag |

### Stacked PR Pattern
```
main ← PR1 (data layer) ← PR2 (service layer) ← PR3 (API layer)
```

Each PR description should note:
```markdown
## Dependencies
- **Depends on**: #123 (data layer changes)
- **Followed by**: #125 (API endpoints)
```

## Reviewer Guidance Section

Help reviewers focus their time:

```markdown
## Review Guidance

### What to focus on
- Retry logic correctness in `OrderService.processPayment()`
- Thread safety of the payment state machine
- Error mapping in `PaymentExceptionHandler`

### What to skip
- `PaymentResponse.java` -- auto-generated record, no manual logic
- `test/fixtures/**` -- test data files, review only if curious

### Context
- Design decision: chose Resilience4j over manual retry loop (see ADR-042)
- The `PaymentGatewayClient` interface matches the external API spec exactly
```

## Automated PR Quality Checks

### Pre-Submission Checklist
```bash
./mvnw clean verify
./mvnw checkstyle:check
./mvnw spotbugs:check
git diff main...HEAD --stat | tail -1
```

### GitHub Actions PR Validation
```yaml
- name: PR Size Check
  run: |
    LINES=$(git diff ${{ github.event.pull_request.base.sha }}...HEAD --stat | tail -1 | awk '{print $4}')
    if [ "$LINES" -gt 1000 ]; then
      echo "::warning::Large PR ($LINES lines changed). Consider splitting."
    fi
```
