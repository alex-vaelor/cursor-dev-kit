# Rules Reference

Complete catalog of all **64** `.mdc` rule files organized by category.

Each rule is a Markdown file with YAML frontmatter that Cursor IDE uses to determine when the rule is active. Rules activate when you open or edit a file matching their `globs` patterns.

---

## Java (12 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `java/coding-standards.mdc` | Java coding standards for naming, formatting, imports, class design, and modern idioms | `**/*.java` |
| `java/modern-features.mdc` | Modern Java feature usage guidance for Java 17/21 including records, sealed classes, pattern matching, and text blocks | `**/*.java` |
| `java/type-design.mdc` | Java type design rules for value objects, type hierarchies, domain modeling, and eliminating primitive obsession | `**/*.java` |
| `java/exception-handling.mdc` | Java exception handling rules for specific exceptions, resource management, fail-fast validation, and logging discipline | `**/*.java` |
| `java/concurrency.mdc` | Java concurrency rules covering virtual threads, thread safety, CompletableFuture, and modern java.util.concurrent patterns | `**/*.java` |
| `java/generics.mdc` | Java generics rules for type-safe API design, bounded types, wildcards, and common pitfalls | `**/*.java` |
| `java/functional-programming.mdc` | Java functional programming rules for streams, lambdas, Optional, and functional exception handling | `**/*.java` |
| `java/logging.mdc` | Java logging conventions for structured logging, log levels, observability, and correlation | `**/*.java` |
| `java/secure-coding.mdc` | Java secure coding rules covering input validation, injection prevention, secrets management, and dependency security | `**/*.java` |
| `java/lombok.mdc` | Lombok usage rules for Java projects — when to use Lombok vs records, safe annotation patterns, JPA entity guidelines, and Spring Boot 4 compatibility | `**/*.java`, `**/lombok.config` |
| `java/jackson.mdc` | Jackson serialization conventions — ObjectMapper configuration, record deserialization, module registration, security, custom serializers, and Spring Boot auto-configuration | `**/src/main/java/**/*.java`, `**/application*.yml`, `**/application*.yaml` |
| `java/mapstruct.mdc` | MapStruct conventions — mapper interfaces, Spring integration, Lombok/record compatibility, nested mappings, custom methods, and Maven annotation processor configuration | `**/src/main/java/**/*Mapper*.java`, `**/pom.xml` |

## Spring (15 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `spring/core.mdc` | Spring Boot core conventions for annotations, bean management, configuration, dependency injection, and application structure | `**/src/main/java/**/*.java`, `**/application*.yml`, `**/application*.properties` |
| `spring/rest-api.mdc` | Spring Boot REST API conventions for HTTP methods, status codes, DTOs, validation, error handling, HATEOAS, and API-first design | `**/src/main/java/**/*Controller*.java`, `**/*Resource*.java`, `**/*Api*.java` |
| `spring/data-access.mdc` | Spring data access conventions for Spring JDBC, Spring Data JDBC, Redis / Spring Data Redis, repository design, and query patterns | `**/src/main/java/**/*Repository*.java`, `**/*Dao*.java`, `**/schema*.sql` |
| `spring/jpa-hibernate.mdc` | JPA and Hibernate conventions — entity design, relationship mapping, fetch strategies, repository patterns, transactions, Hibernate configuration, and anti-patterns | `**/*Entity*.java`, `**/*Repository*.java`, `**/*Service*.java`, `**/application*.yml` |
| `spring/security.mdc` | Spring Security conventions for authentication, authorization, and HTTP security configuration | `**/*Security*.java`, `**/*Auth*.java` |
| `spring/migrations.mdc` | Database migration conventions using Flyway with Spring Boot | `**/db/migration/**/*.sql`, `**/flyway*.properties`, `**/flyway*.yml` |
| `spring/retry-cache.mdc` | Spring Retry and Spring Cache conventions — declarative retry with @Retryable, cache strategies with @Cacheable, idempotency requirements, cache key design, TTL, and backend selection | `**/*Service*.java`, `**/*Cache*.java`, `**/*Retry*.java` |
| `spring/aop.mdc` | Spring AOP conventions — aspect placement, pointcut expressions, advice ordering, common cross-cutting concerns, proxy limitations, and testing aspects | `**/*Aspect*.java`, `**/*Interceptor*.java` |
| `spring/actuator.mdc` | Spring Boot Actuator conventions — endpoint exposure, security hardening, custom health indicators, Micrometer metrics, Kubernetes probes, and Prometheus integration | `**/application*.yml`, `**/*Health*.java`, `**/*Metric*.java` |
| `spring/validation.mdc` | Jakarta Bean Validation and Hibernate Validator conventions — DTO validation, entity constraints, custom validators, validation groups, cross-field validation, and method-level validation | `**/*Request*.java`, `**/*Dto*.java`, `**/*Validator*.java`, `**/*Controller*.java` |
| `spring/graphql.mdc` | Spring for GraphQL conventions — schema design, controller mappings, DataLoader for N+1 prevention, security, error handling, and testing with GraphQlTester | `**/*.graphqls`, `**/*GraphQl*.java`, `**/*Controller*.java` |
| `spring/testing-unit.mdc` | Spring Boot unit testing conventions using slice tests (@WebMvcTest, @DataJdbcTest, @DataJpaTest), MockMvc, and Mockito | `**/src/test/**/*Test.java` |
| `spring/testing-integration.mdc` | Spring Boot integration testing conventions using @SpringBootTest, Testcontainers, and WireMock | `**/src/test/**/*IntegrationTest.java`, `**/*IT.java` |
| `spring/testing-acceptance.mdc` | Spring Boot acceptance testing conventions for end-to-end API and contract testing | `**/src/test/**/*AcceptanceTest.java`, `**/*AT.java` |

## Testing (5 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `testing/strategy.mdc` | Testing strategy for Java projects covering test pyramid, coverage targets, and test organization | `**/src/test/**/*.java` |
| `testing/unit-testing.mdc` | Java unit testing rules for JUnit 5/6, AssertJ, Mockito, and test quality | `**/src/test/**/*Test.java` |
| `testing/integration-testing.mdc` | Java integration testing rules for Testcontainers, database testing, and external service testing | `**/src/test/**/*IntegrationTest.java`, `**/*IT.java` |
| `testing/acceptance-testing.mdc` | Acceptance testing rules for end-to-end Java API testing and workflow verification | `**/src/test/**/*AcceptanceTest.java`, `**/*AT.java` |
| `testing/tdd-workflow.mdc` | Test-Driven Development workflow rules for Red-Green-Refactor discipline | `**/src/test/**/*.java`, `**/src/main/java/**/*.java` |

## Architecture (5 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `architecture/adr.mdc` | Architecture Decision Records (ADR) creation and management — MADR template, decision lifecycle, and documentation standards | `**/docs/adr/**`, `**/ADR-*.md` |
| `architecture/ddd.mdc` | Domain-Driven Design rules — strategic design (bounded contexts, context mapping) and tactical patterns (aggregates, entities, value objects, domain events) | `**/src/main/java/**/domain/**` |
| `architecture/design-patterns.mdc` | Architecture-level design patterns — layered, hexagonal, CQRS, event sourcing, and microservices patterns for Java systems | `**/src/main/java/**` |
| `architecture/diagrams.mdc` | Architecture diagram conventions — C4 model levels, UML diagrams, PlantUML syntax, and diagram-as-code practices | `**/*.puml`, `**/*.plantuml`, `**/docs/diagrams/**` |
| `architecture/microservices.mdc` | Microservices architecture rules — service boundaries, communication patterns, data ownership, resilience, and observability for distributed Java systems | `**/src/main/java/**` |

## Security (2 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `security/application-security.mdc` | Application security rules for Java applications covering OWASP Top 10, input validation, and security defaults | `**/*.java` |
| `security/api-security.mdc` | API security rules for REST APIs covering OWASP API Security Top 10, authentication, rate limiting, CORS, transport security, and Spring Security patterns | `**/*Controller*.java`, `**/*Security*.java`, `**/*Filter*.java` |

## SQL (3 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `sql/database-design.mdc` | Database schema design rules — normalization, data types, naming conventions, constraints, and migration-friendly design for relational databases | `**/*.sql`, `**/db/migration/**` |
| `sql/query-optimization.mdc` | SQL query optimization rules — indexing strategy, query patterns, EXPLAIN ANALYZE, N+1 prevention, and performance tuning for relational databases | `**/*.sql`, `**/*Repository*.java` |
| `sql/migrations.mdc` | Database migration rules — Flyway conventions, migration file structure, versioning, rollback strategy, and zero-downtime migration patterns | `**/db/migration/**`, `**/src/main/resources/db/**`, `**/*.sql` |

## Build (3 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `build/maven.mdc` | Maven build conventions for POM structure, dependency management, plugins, and multi-module projects | `**/pom.xml` |
| `build/gradle.mdc` | Gradle build conventions for Kotlin DSL, version catalogs, dependency management, and task configuration | `**/build.gradle`, `**/build.gradle.kts`, `**/settings.gradle*`, `**/libs.versions.toml` |
| `build/maven-documentation.mdc` | Maven documentation and reporting conventions for site generation, Javadoc, and project metadata | `**/pom.xml` |

## Git (7 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `git/workflow.mdc` | Git branching strategy, merge rules, and branch lifecycle management | `**/.git/**`, `**/.github/**` |
| `git/commit-conventions.mdc` | Conventional commit message format, types, structure, and linking rules | `**/.git/**`, `**/.gitconfig` |
| `git/branch-naming.mdc` | Branch naming conventions, patterns, validation rules, and examples | `**/.git/**` |
| `git/pull-request-quality.mdc` | Pull request standards including description requirements, size limits, review readiness, and self-review checklist | `**/.github/**` |
| `git/code-review-standards.mdc` | Code review process, feedback quality, severity levels, approval criteria, and reviewer responsibilities | `**/.github/**` |
| `git/github.mdc` | GitHub CLI usage, GitHub Actions patterns, issue and PR management, and API conventions | `**/.github/**`, `**/.github/workflows/**` |
| `git/repository-hygiene.mdc` | Repository cleanliness rules including gitignore, secrets prevention, binary handling, LFS, history hygiene, and tag conventions | `**/.gitignore`, `**/.gitattributes`, `**/.git/**` |

## Docker (2 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `docker/containers.mdc` | General Docker container conventions — Dockerfile best practices, image optimization, security, Compose patterns, and development workflow | `**/Dockerfile*`, `**/docker-compose*.yml`, `**/.dockerignore` |
| `docker/java-containers.mdc` | Docker conventions for Java applications including multi-stage builds, JVM tuning, and image security | `**/Dockerfile*`, `**/*.dockerfile`, `**/docker-compose*.yml` |

## Core (4 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `core/project-conventions.mdc` | Project-wide conventions for naming, structure, file organization, and consistency | `**/*` (alwaysApply: true) |
| `core/code-quality.mdc` | Code quality standards including readability, maintainability, SOLID principles, and anti-patterns | `**/*.java` |
| `core/documentation.mdc` | Documentation standards for code comments, Javadoc, README files, and project documentation | `**/*.java`, `**/*.md`, `**/README*`, `**/CHANGELOG*` |
| `core/agents-md-generator.mdc` | Guidelines for generating AGENTS.md files that document project conventions for AI agents and contributors | `**/AGENTS.md` |

## Agile (4 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `agile/epics.mdc` | Agile epic definition rules — structure, business value, scope, success criteria, and breakdown patterns for large initiatives | `**/docs/epics/**`, `**/docs/agile/**` |
| `agile/features.mdc` | Agile feature definition rules — structure, scope, acceptance criteria, and relationship to epics and user stories | `**/docs/features/**`, `**/docs/agile/**` |
| `agile/user-stories.mdc` | Agile user story rules — format, INVEST criteria, acceptance criteria with Gherkin, and story splitting patterns | `**/docs/stories/**`, `**/*.feature` |
| `agile/planning.mdc` | Agile planning rules — sprint planning, plan mode workflow, estimation, backlog management, and structured implementation plans | `**/.cursor/plans/**`, `**/docs/plans/**` |

## Bash (1 rule)

| Rule | Description | Globs |
|------|-------------|-------|
| `bash/scripting.mdc` | Bash scripting conventions — strict mode, error handling, argument parsing, logging, and defensive patterns for production-ready shell scripts | `**/*.sh`, `**/*.bash` |

## Behaviour (2 rules)

| Rule | Description | Globs |
|------|-------------|-------|
| `behaviour/consultative.mdc` | Consultative interaction behavior — analyze before acting, propose options with trade-offs, and ask for user choice before implementing changes | _(no globs — context-driven)_ |
| `behaviour/progressive-learning.mdc` | Progressive learning behavior — teach principles and build understanding by explaining the "why" behind recommendations, with progressive complexity and good vs bad comparisons | _(no globs — context-driven)_ |
