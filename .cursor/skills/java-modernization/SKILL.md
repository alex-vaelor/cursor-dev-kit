---
name: java-modernization
description: "Use when migrating Java applications to modern baselines -- including Java 8 to 17, Java 17 to 21, Spring Boot 2/3 to 4, javax to jakarta namespace, legacy pattern modernization, and OpenRewrite automated migration."
risk: critical
source: extended
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: quality
  triggers: migration, modernize, upgrade, legacy, javax, jakarta, java 8, java 11, java 17, java 21, spring boot upgrade, OpenRewrite
  role: specialist
  scope: java-modernization
  related-skills: java-modern-features, spring-boot-core, maven-build
---

# Java Modernization

Guide Java and Spring application migrations to modern baselines with systematic detection, planning, and execution.

## When to Use This Skill

- Migrate Java 8/11 applications to Java 17
- Migrate Java 17 applications to Java 21
- Upgrade Spring Boot 2.x/3.x to 4.x
- Replace `javax.*` imports with `jakarta.*`
- Modernize legacy patterns (pre-Java 8 idioms, manual resource management)
- Detect deprecated APIs and suggest replacements

## Workflow

1. **Assess**: Identify current Java version, Spring version, and dependency baseline.
2. **Detect**: Scan for deprecated APIs, legacy patterns, and version-incompatible code.
3. **Plan**: Create a prioritized migration plan with risk assessment.
4. **Execute**: Apply changes incrementally, verifying compilation and tests after each step.
5. **Verify**: Run full test suite and manual smoke tests after migration.

## Constraints

- **MANDATORY**: Run `./mvnw compile` before and after each migration step
- **INCREMENTAL**: Apply changes in small, verifiable increments
- **TESTS**: Run `./mvnw clean verify` after each increment
- **BACKUP**: Ensure all changes are committed or stashed before starting

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Java 8 to 17 migration | `references/migration-java-8-to-17.md` | When upgrading from Java 8/11 to 17 |
| Java 17 to 21 migration | `references/migration-java-17-to-21.md` | When upgrading from Java 17 to 21 |
| Spring Boot migration | `references/spring-boot-migration.md` | When upgrading Spring Boot |

## Assets

| File | Purpose |
|------|---------|
| `assets/modernization-checklist.md` | Step-by-step modernization checklist |

## Related Rules

- `rules/java/modern-features.mdc` -- modern feature usage
- Shared: `shared/supported-version-matrix.md` -- version compatibility
