# Technical Debt Management for Java Projects

## What Is Technical Debt

Technical debt is the implied cost of future rework caused by choosing a quick solution now instead of a better approach. It accumulates across code, architecture, testing, documentation, and infrastructure.

## Debt Categories

| Category | Examples | Detection |
|----------|----------|-----------|
| **Code debt** | Long methods, duplicated logic, primitive obsession, raw types | Checkstyle, SpotBugs, PMD, SonarQube |
| **Architecture debt** | Circular dependencies, god classes, wrong layer access | ArchUnit tests, dependency analysis |
| **Test debt** | Low coverage, flaky tests, missing integration tests | JaCoCo reports, test result trends |
| **Documentation debt** | Missing Javadoc, outdated README, no ADRs | Javadoc warnings, manual audit |
| **Dependency debt** | Outdated libraries, known CVEs, deprecated APIs | `versions:display-dependency-updates`, OWASP Dependency-Check |
| **Infrastructure debt** | Manual deployments, missing CI checks, no Docker | CI pipeline audit |

## Quantification Framework

### Impact Scoring (1-5)

| Score | Impact | Example |
|-------|--------|---------|
| 5 | **Critical** | Security vulnerability, data loss risk |
| 4 | **High** | Every feature change requires touching this code |
| 3 | **Medium** | Slows development but workarounds exist |
| 2 | **Low** | Minor inconvenience, cosmetic |
| 1 | **Minimal** | Style preference, no functional impact |

### Effort Scoring (1-5)

| Score | Effort | Example |
|-------|--------|---------|
| 5 | **Very high** | Multi-sprint, architectural change |
| 4 | **High** | Full sprint, cross-module refactoring |
| 3 | **Medium** | Few days, single module |
| 2 | **Low** | Hours, single class/file |
| 1 | **Trivial** | Minutes, rename/format |

### Priority = Impact / Effort
Items with highest ratio should be addressed first.

## Detection with Maven Toolchain

### Static Analysis
```bash
./mvnw checkstyle:check           # Style violations
./mvnw spotbugs:check             # Bug patterns
./mvnw pmd:check                  # Code smells, copy-paste
./mvnw pmd:cpd-check              # Duplicate code detection
```

### Coverage Gaps
```bash
./mvnw jacoco:report              # Generate coverage report
# Review target/site/jacoco/index.html
# Flag classes with <60% line coverage
```

### Dependency Freshness
```bash
./mvnw versions:display-dependency-updates
./mvnw versions:display-plugin-updates
./mvnw dependency-check:check     # CVE scanning
```

### Architecture Violations
```java
@AnalyzeClasses(packages = "com.example")
class ArchitectureDebtTest {
    @ArchTest
    static final ArchRule no_cycles = slices()
        .matching("com.example.(*)..")
        .should().beFreeOfCycles();

    @ArchTest
    static final ArchRule services_dont_access_web = noClasses()
        .that().resideInAPackage("..service..")
        .should().dependOnClassesThat().resideInAPackage("..web..");
}
```

## Tech Debt Inventory Template

```markdown
## TD-001: OrderService exceeds 500 lines (God Class)
- **Category**: Code debt
- **Impact**: 4 (every order change touches this file; merge conflicts frequent)
- **Effort**: 3 (extract 3 services: OrderCreation, OrderFulfillment, OrderNotification)
- **Priority**: 1.33 (high)
- **File**: `src/main/java/com/example/order/service/OrderService.java`
- **Action**: Extract Method -> Extract Class for each responsibility
- **Blocked by**: Need integration tests first (test debt TD-005)
```

## Remediation Strategy

### Sprint Budget
Reserve 10-20% of sprint capacity for tech debt reduction. Track velocity impact over 3+ sprints.

### Quick Wins First
Address high-priority, low-effort items in every sprint:
- Fix Checkstyle/SpotBugs warnings
- Update vulnerable dependencies
- Add missing `@Nullable`/`@NullMarked` annotations
- Convert mutable DTOs to records

### Incremental Architecture Fixes
- Add ArchUnit tests to prevent new violations
- Refactor one module at a time; keep the rest stable
- Use the Strangler Fig pattern for large-scale rewrites

### Prevention
- Add quality gates to CI (Checkstyle, SpotBugs, JaCoCo thresholds)
- Enforce ArchUnit rules in every build
- Require code review for all PRs
- Run `dependency-check` in CI weekly

## KPIs for Tech Debt Tracking

| Metric | Source | Target |
|--------|--------|--------|
| SonarQube debt ratio | SonarQube dashboard | <5% |
| Known CVEs (HIGH+) | OWASP Dependency-Check | 0 |
| Test coverage (line) | JaCoCo | >=80% |
| ArchUnit violations | Test results | 0 |
| Outdated dependencies | `versions` plugin | <10% of total |
| Average code smell density | PMD/SonarQube | Decreasing trend |
