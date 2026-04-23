# Toolchain Standards

Standard tools, versions, and configurations for Java projects in this workspace.

## JDK

| Setting | Value |
|---------|-------|
| Distribution | Eclipse Temurin (Adoptium) or Amazon Corretto |
| Minimum version | 17 LTS |
| Recommended version | 21 LTS |
| Version manager | SDKMAN! (`sdk install java 21-tem`) or `.java-version` file |

Configure `.java-version` in the project root for reproducibility:
```
21
```

## Build Tool

### Maven (Primary)
| Setting | Value |
|---------|-------|
| Version | 3.9.x |
| Wrapper | Always use Maven Wrapper (`mvnw` / `mvnw.cmd`) |
| Settings | Project-local `.mvn/maven.config` for JVM args |
| POM style | Use `<dependencyManagement>` + BOM for version centralization |

### Gradle (Alternative)
| Setting | Value |
|---------|-------|
| Version | 8.x |
| Wrapper | Always use Gradle Wrapper (`gradlew` / `gradlew.bat`) |
| DSL | Kotlin DSL (`build.gradle.kts`) preferred for new projects |
| Catalog | Use version catalogs (`libs.versions.toml`) for dependency centralization |

## Code Quality Tools

| Tool | Purpose | Plugin |
|------|---------|--------|
| Checkstyle | Style enforcement | `maven-checkstyle-plugin` / `checkstyle` Gradle plugin |
| Spotless | Code formatting | `spotless-maven-plugin` / `spotless` Gradle plugin |
| SpotBugs | Static bug detection | `spotbugs-maven-plugin` / `spotbugs` Gradle plugin |
| PMD | Code smell detection | `maven-pmd-plugin` / `pmd` Gradle plugin |
| OWASP Dependency-Check | CVE scanning | `dependency-check-maven` / `dependency-check` Gradle plugin |
| JaCoCo | Code coverage | `jacoco-maven-plugin` / `jacoco` Gradle plugin |
| ArchUnit | Architecture rules | Test dependency (`com.tngtech.archunit:archunit-junit5`) |
| Error Prone | Compile-time checks | Compiler plugin integration |
| JSpecify | Null safety annotations | `org.jspecify:jspecify` dependency |
| NullAway | Null safety enforcement | Error Prone check |
| Lombok | Boilerplate reduction | `org.projectlombok:lombok` (provided scope) |
| OpenRewrite | Automated code migration | `org.openrewrite.maven:rewrite-maven-plugin` |

## Testing Tools

| Tool | Purpose | Scope |
|------|---------|-------|
| JUnit 5/6 | Test framework | All tests |
| AssertJ | Fluent assertions | All tests |
| Mockito | Mocking | Unit tests |
| Testcontainers | Container-based integration | Integration tests |
| WireMock | HTTP service stubs | Integration tests |
| Spring Test | Spring context testing | Spring tests |
| REST Assured | HTTP API testing | API tests |

## IDE Configuration

### EditorConfig (`.editorconfig`)
```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.java]
indent_style = space
indent_size = 4
max_line_length = 120

[*.{yml,yaml}]
indent_style = space
indent_size = 2

[*.xml]
indent_style = space
indent_size = 4
```

### Checkstyle Configuration
Use a project-specific `checkstyle.xml` based on Google Java Style with these overrides:
- Line length: 120 (instead of 100)
- Indentation: 4 spaces
- Import ordering: `java`, `jakarta`, third-party, project

### IntelliJ IDEA Settings
- Import the project Checkstyle config as the formatter
- Enable "Optimize imports on the fly"
- Enable "Add unambiguous imports on the fly"
- Set copyright header if required

## Docker

| Setting | Value |
|---------|-------|
| Base image | `eclipse-temurin:21-jre-alpine` (runtime) or `eclipse-temurin:21-jdk-alpine` (build) |
| Build strategy | Multi-stage: build with JDK, run with JRE |
| Alternative | Jib (`jib-maven-plugin`) for OCI images without Dockerfile |
| Distroless option | `gcr.io/distroless/java21-debian12` for minimal attack surface |

## Persistence

| Tool | Purpose |
|------|---------|
| Hibernate ORM | JPA implementation; entity mapping, caching, batch processing |
| Spring Data JPA | Repository abstraction over JPA (`JpaRepository`, specifications, projections) |
| Hibernate Envers | Entity audit history (`@Audited`, revision queries) |
| Flyway | Database migration versioning and execution |

## Mapping & Serialization

| Tool | Purpose |
|------|---------|
| MapStruct | Compile-time type-safe bean mapping; annotation processor |
| Jackson | JSON serialization/deserialization; auto-configured by Spring Boot |

## Caching & Data Stores

| Tool | Purpose |
|------|---------|
| Redis (Lettuce) | Distributed cache, session store, rate limiting |
| Caffeine | High-performance local in-memory cache |

## Monitoring & Observability

| Tool | Purpose |
|------|---------|
| Spring Boot Actuator | Health, info, metrics, and management endpoints |
| Micrometer | Application metrics facade (Counter, Timer, Gauge) |
| Prometheus | Metrics collection and alerting |

## CI/CD

| Tool | Purpose |
|------|---------|
| GitHub Actions | Primary CI/CD platform |
| Maven Wrapper | Reproducible builds in CI |
| Renovate / Dependabot | Automated dependency updates |
| GitHub secret scanning | Prevent secret leaks |
| OWASP Dependency-Check | CVE scanning in pipeline |
