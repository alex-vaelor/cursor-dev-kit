---
name: maven-build
description: "Use when reviewing, improving, or troubleshooting Maven POM files -- including dependency management with BOMs, plugin configuration, multi-module structure, build profiles, version centralization, and Maven best practices."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: maven, pom.xml, dependency, plugin, BOM, multi-module, build, mvnw, compile, verify
  role: specialist
  scope: maven-build
  original-author: Juan Antonio Breña Moral
  related-skills: java-code-review, spring-boot-core
---

# Maven Build

Improve Maven POM configuration, dependency management, plugin setup, and multi-module project structure.

## When to Use This Skill

- Review or improve `pom.xml` configuration
- Set up dependency management with BOMs
- Configure build plugins (Surefire, Failsafe, JaCoCo, Checkstyle, SpotBugs)
- Structure multi-module Maven projects
- Troubleshoot build issues
- Search for Maven artifacts and versions
- Generate project documentation with Maven Site

## Coverage

### Best Practices
- `<dependencyManagement>` with BOMs for version centralization
- Standard directory layout
- Build profiles for environment-specific settings
- Properties for version strings

### Dependencies
- BOM import and dependency management
- Scope management (compile, test, provided, runtime)
- Version conflict resolution
- Dependency exclusions and overrides

### Plugins
- Surefire (unit tests), Failsafe (integration tests)
- JaCoCo (coverage), Checkstyle (formatting), SpotBugs (static analysis)
- Enforcer (constraints), Versions (dependency updates)
- OpenAPI Generator for API-first development

### Multi-Module
- Root POM: `<modules>`, shared properties, managed dependencies
- Child POMs: inherit parent, no hardcoded versions
- Cross-module consistency checks

### Documentation
- Maven Site generation
- Javadoc plugin configuration
- Project metadata

### Search
- Finding Maven artifacts and versions
- Checking Maven Central for available dependencies

## Constraints

- **MANDATORY**: Run `./mvnw validate` before applying recommendations
- **MULTI-MODULE**: When `<modules>` exists, read ALL child POMs before recommending
- **VERIFY**: Run `./mvnw clean verify` after changes
- **SAFETY**: If validation fails, stop and ask the user to fix

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Maven best practices | `references/best-practices.md` | When reviewing POM structure |
| Dependency management | `references/dependencies.md` | When managing dependencies |
| Plugin configuration | `references/plugins.md` | When configuring build plugins |
| Documentation generation | `references/documentation.md` | When setting up Maven Site |
| Artifact search | `references/search.md` | When finding dependencies |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/validate-build.sh` | Run Maven validation and compilation |
| `scripts/dependency-audit.sh` | Audit dependency tree and check for issues |

## Related Rules

- `rules/build/maven.mdc` -- Maven conventions
- `rules/build/maven-documentation.mdc` -- documentation conventions
