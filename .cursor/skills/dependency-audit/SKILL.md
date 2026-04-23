---
name: dependency-audit
description: "Use when auditing project dependencies -- including vulnerability scanning (CVE), license compliance, outdated dependency detection, supply chain security, and dependency conflict resolution for Maven and Gradle projects."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: security
  triggers: dependency audit, CVE, vulnerability, OWASP dependency check, outdated dependencies, license, supply chain, dependency conflict, dependency tree
  role: specialist
  scope: dependency-security
  related-skills: maven-build, java-secure-coding, build-release-helper
---

# Dependency Audit

Audit Java project dependencies for vulnerabilities, license compliance, freshness, and supply chain risks.

## When to Use This Skill

- Scan for known CVEs in project dependencies
- Check license compliance for all dependencies
- Identify outdated dependencies needing upgrades
- Resolve dependency conflicts and version drift
- Review supply chain security (transitive dependencies)
- Prepare for release by ensuring clean dependency state

## Audit Workflow

1. **Inventory**: Map all direct and transitive dependencies
2. **Vulnerabilities**: Scan for known CVEs
3. **Licenses**: Verify all dependencies meet license policy
4. **Freshness**: Identify outdated dependencies and available updates
5. **Conflicts**: Detect version conflicts and convergence issues
6. **Report**: Produce prioritized findings with remediation steps

## Maven Commands

```bash
# Dependency tree (full graph)
./mvnw dependency:tree

# Show outdated dependencies
./mvnw versions:display-dependency-updates
./mvnw versions:display-plugin-updates

# CVE scanning
./mvnw dependency-check:check
# Report at: target/dependency-check-report.html

# Analyze unused/undeclared dependencies
./mvnw dependency:analyze

# Enforce dependency convergence
./mvnw enforcer:enforce
```

## Gradle Commands

```bash
# Dependency tree
./gradlew dependencies

# Outdated dependencies (with plugin)
./gradlew dependencyUpdates

# CVE scanning
./gradlew dependencyCheckAnalyze
```

## Constraints

- **MANDATORY**: Run audit before every release
- **CRITICAL CVEs**: Block release until resolved or documented with risk acceptance
- **LICENSE**: No GPL-licensed dependencies in proprietary projects without legal review
- **SNAPSHOTS**: No SNAPSHOT dependencies in release builds

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Dependency audit guide | `references/dependency-audit-guide.md` | When performing full audit |

## Related Rules

- `rules/build/maven.mdc` -- Maven conventions
- `rules/security/application-security.mdc` -- application security
- `rules/java/secure-coding.mdc` -- secure coding

## Related Skills

- `skills/maven-build/` -- Maven configuration
- `skills/java-secure-coding/` -- secure coding practices
