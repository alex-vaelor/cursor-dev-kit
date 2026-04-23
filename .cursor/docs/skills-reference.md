# Skills Reference

Complete catalog of all **46** skill packages organized by category.

Each skill lives in `skills/<name>/` and contains a `SKILL.md` entry point, a `references/` directory with supporting guides, and optionally a `scripts/` directory with automation helpers (`.sh` + `.ps1` pairs).

---

## Java Core (10 skills)

### java-oop-design

Object-oriented design guidelines and refactoring practices — SOLID, DRY, YAGNI, code smells, and class design.

- **Triggers**: oop, object-oriented, SOLID, DRY, YAGNI, class design, interface design, code smell, refactor, God Class, Feature Envy
- **References**: `oop-design-guidelines.md`, `apache-commons-guide.md`

### java-type-design

Type design principles for maximum clarity and maintainability — value objects, domain modeling, and eliminating primitive obsession.

- **Triggers**: type design, value object, primitive obsession, BigDecimal, fluent interface, builder, record, sealed class, type safety
- **References**: `type-design-guidelines.md`, `jspecify-guide.md`

### java-design-patterns

Classic and modern GoF design patterns implemented with Java 17/21 features (records, sealed classes, lambdas) and Spring integration.

- **Triggers**: design pattern, factory, builder, strategy, observer, decorator, singleton, adapter, proxy, template method
- **References**: `design-patterns-guide.md`

### java-concurrency

Java concurrency best practices for thread safety, scalability, and maintainability using `java.util.concurrent` and virtual threads.

- **Triggers**: concurrency, thread, virtual thread, CompletableFuture, ExecutorService, synchronized, lock, deadlock, parallel, async
- **References**: `concurrency-guidelines.md`

### java-generics

Generics best practices for type-safe, reusable APIs — bounded types, wildcards, PECS, and common pitfalls.

- **Triggers**: generics, type parameter, wildcard, PECS, type erasure, raw type, unchecked cast, bounded type
- **References**: `generics-guidelines.md`

### java-functional

Functional programming patterns for declarative, composable data transformations — streams, lambdas, Optional.

- **Triggers**: stream, lambda, Optional, functional, map, filter, reduce, method reference, CompletableFuture, Either, Result
- **References**: `functional-programming.md`, `functional-exception-handling.md`

### java-exception-handling

Comprehensive exception handling best practices for robust, secure, and debuggable Java code.

- **Triggers**: exception, error handling, try-with-resources, try-catch, throw, logging, retry, timeout, fail-fast
- **References**: `exception-handling-guidelines.md`, `resilience-patterns.md`

### java-secure-coding

Secure coding practices aligned with OWASP guidelines — injection prevention, secrets management, authentication, authorization.

- **Triggers**: security, secure coding, injection, XSS, OWASP, CVE, vulnerability, secrets, authentication, authorization
- **References**: `secure-coding-guidelines.md`, `jwt-security-patterns.md`

### java-modern-features

Modern Java 17 and 21 language features — records, sealed classes, pattern matching, switch expressions, text blocks, virtual threads.

- **Triggers**: modern java, record, sealed class, pattern matching, switch expression, text block, var, refactor to modern, data-oriented
- **References**: `refactoring-to-modern-java.md`, `data-oriented-programming.md`

### java-modernization

Migration guidance for Java and Spring applications to modern baselines with systematic detection, planning, and execution.

- **Triggers**: migration, modernize, upgrade, legacy, javax, jakarta, java 8, java 11, java 17, java 21, spring boot upgrade, OpenRewrite
- **References**: `migration-java-8-to-17.md`, `migration-java-17-to-21.md`, `spring-boot-migration.md`

---

## Spring (10 skills)

### spring-boot-core

Spring Boot core guidelines for annotations, bean management, configuration, and dependency injection. Aligned with Spring Boot 4.0.x / Spring Framework 7.0.x.

- **Triggers**: spring boot, spring, bean, autowired, configuration, profile, spring boot 4, jakarta
- **References**: `core-guidelines.md`, `backend-architecture-checklist.md`

### spring-boot-rest

REST API design and review with Spring Boot using HTTP semantics, DTOs, validation, and API-first practices.

- **Triggers**: REST, API, controller, endpoint, HTTP, OpenAPI, swagger, validation, error handling, problem details
- **References**: `rest-api-guidelines.md`

### spring-boot-security

Spring Security configurations for Spring Boot 4.x / Spring Security 7.x — SecurityFilterChain, OAuth2, JWT, CORS, CSRF, method security.

- **Triggers**: spring security, authentication, authorization, JWT, OAuth2, SecurityFilterChain, CORS, CSRF, method security, @PreAuthorize
- **References**: `security-implementation.md`

### spring-boot-testing

Spring Boot testing across slice tests, Testcontainers, and WireMock — @WebMvcTest, @DataJdbcTest, @DataJpaTest, @SpringBootTest.

- **Triggers**: spring test, WebMvcTest, DataJdbcTest, DataJpaTest, SpringBootTest, MockitoBean, testcontainers, WireMock, slice test
- **References**: `unit-testing.md`, `integration-testing.md`, `acceptance-testing.md`, `test-database-patterns.md`

### spring-jpa-patterns

JPA/Hibernate in Spring applications — entity design, optimized queries, transaction management, advanced mapping, auditing, and performance.

- **Triggers**: JPA, Hibernate, entity, N+1, LazyInitializationException, @Entity, @OneToMany, @ManyToOne, EntityGraph, JPQL, Spring Data JPA, @Transactional, specification, second-level cache, L2 cache, batch insert, Envers, @Audited, @Embeddable, inheritance mapping, AttributeConverter
- **References**: `jpa-guidelines.md`, `jpa-troubleshooting.md`, `validation-patterns.md`, `entity-mapping-advanced.md`, `hibernate-performance.md`, `hibernate-envers.md`

### spring-data-access

Data access patterns with Spring JDBC, Spring Data JDBC, and Flyway.

- **Triggers**: repository, JDBC, Spring Data, JdbcClient, Flyway, migration, database, SQL, transaction, aggregate
- **References**: `spring-jdbc.md`, `spring-data-jdbc.md`, `flyway-migrations.md`

### spring-cache-retry

Caching strategies and retry logic for Spring Boot — @Cacheable, @CacheEvict, @Retryable, @Recover, TTL, Redis, Caffeine.

- **Triggers**: cache, caching, @Cacheable, @CacheEvict, eviction, TTL, Redis cache, Caffeine, retry, @Retryable, @Recover, RetryTemplate, backoff, idempotent
- **References**: `cache-patterns.md`, `retry-patterns.md`

### spring-graphql

GraphQL APIs using Spring for GraphQL with schema-first design — @QueryMapping, @MutationMapping, DataLoader, @BatchMapping, GraphQlTester.

- **Triggers**: GraphQL, graphql, @QueryMapping, @MutationMapping, @SchemaMapping, @BatchMapping, DataLoader, GraphQlTester, schema.graphqls
- **References**: `graphql-implementation.md`

### spring-actuator-monitoring

Production-ready monitoring with Spring Boot Actuator and Micrometer — health checks, metrics, Prometheus, Kubernetes probes.

- **Triggers**: actuator, health check, metrics, Micrometer, Prometheus, Grafana, monitoring, observability, counter, timer, gauge, Kubernetes probes, liveness, readiness
- **References**: `actuator-guide.md`, `micrometer-patterns.md`

### spring-cloud

Distributed Spring Boot applications with Spring Cloud — service discovery, config server, API gateway, circuit breaker, distributed tracing.

- **Triggers**: spring cloud, service discovery, eureka, config server, api gateway, circuit breaker, resilience4j, distributed tracing, micrometer, kubernetes, load balancer
- **References**: `cloud-guidelines.md`

---

## Testing (2 skills)

### java-testing

Modern JUnit, AssertJ, and Mockito best practices across unit, integration, and acceptance testing.

- **Triggers**: test, junit, mockito, assertj, unit test, integration test, acceptance test, coverage, TDD, parameterized test, testcontainers
- **References**: `testing-strategy.md`, `unit-testing.md`, `integration-testing.md`, `acceptance-testing.md`, `jacoco-coverage.md`, `archunit-guidelines.md`, `wiremock-guidelines.md`
- **Scripts**: `run-tests.sh` / `run-tests.ps1`, `coverage-report.sh` / `coverage-report.ps1`

### tdd-workflow

Test-Driven Development using the Red-Green-Refactor cycle.

- **Triggers**: TDD, test-driven development, red green refactor, outside-in, inside-out, test first, failing test
- **References**: `tdd-cycle.md`, `tdd-anti-patterns.md`

---

## Architecture (3 skills)

### architecture-design

System architecture design with ADRs, C4 diagrams, pattern selection, and architecture principles.

- **Triggers**: architecture, system design, ADR, C4 diagram, architectural pattern, NFR, non-functional requirements, trade-off analysis, scalability, architecture review
- **References**: `system-design.md`, `architecture-patterns.md`, `architecture-principles.md`, `adr-template.md`, `nfr-checklist.md`, `database-selection.md`, `context-discovery.md`, `pattern-selection.md`, `patterns-reference.md`

### ddd-patterns

Domain-Driven Design strategic and tactical patterns for complex business domains.

- **Triggers**: DDD, domain-driven design, bounded context, aggregate, value object, domain event, context mapping, ubiquitous language, subdomain, anti-corruption layer
- **References**: `strategic-design-template.md`, `tactical-checklist.md`, `context-map-patterns.md`

### saga-patterns

Distributed transactions using saga patterns — choreography, orchestration, compensation, idempotency.

- **Triggers**: saga, distributed transaction, compensation, choreography, orchestration, state machine, idempotency, eventual consistency, cross-service transaction
- **References**: `saga-implementation.md`

---

## Data (1 skill)

### database-design

Relational database schema design with normalization, indexing, migration strategy, and multi-tenant patterns.

- **Triggers**: database design, schema, normalization, indexing, SQL optimization, migration, EXPLAIN ANALYZE, N+1, database selection, PostgreSQL
- **References**: `schema-design.md`, `indexing.md`, `query-optimization.md`, `migrations.md`, `database-selection.md`, `multi-tenant-patterns.md`

---

## API (1 skill)

### api-design

REST API design and documentation following OpenAPI specification — authentication, rate limiting, HATEOAS, response patterns.

- **Triggers**: API design, REST API, OpenAPI, Swagger, API versioning, pagination, HATEOAS, RFC 9457, API review, resource modeling
- **References**: `rest-api-guidelines.md`, `openapi-conventions.md`, `api-authentication.md`, `api-response-patterns.md`, `rate-limiting.md`, `hateoas-guide.md`

---

## DevOps (3 skills)

### maven-build

Maven POM configuration, dependency management, plugin setup, and multi-module project structure.

- **Triggers**: maven, pom.xml, dependency, plugin, BOM, multi-module, build, mvnw, compile, verify
- **References**: `best-practices.md`, `dependencies.md`, `plugins.md`, `documentation.md`, `search.md`
- **Scripts**: `validate-build.sh` / `validate-build.ps1`, `dependency-audit.sh` / `dependency-audit.ps1`

### docker-containers

Docker containers for Java and general application deployment — multi-stage builds, image optimization, security, Compose.

- **Triggers**: Docker, Dockerfile, container, docker-compose, multi-stage build, container security, image optimization, distroless
- **References**: `docker-patterns.md`

### bash-scripting

Production-ready shell scripts with defensive patterns, structured error handling, and testing.

- **Triggers**: bash, shell script, sh, automation script, deployment script, CI script, ShellCheck
- **References**: `bash-patterns.md`

---

## Git / GitHub (6 skills)

### git-workflow

Advanced Git operations — branching, rebasing, cherry-picking, bisecting, worktrees, recovery.

- **Triggers**: git rebase, cherry-pick, bisect, worktree, reflog, merge conflict, branch cleanup, history rewrite, git workflow
- **References**: `advanced-git.md`, `branching-strategies.md`, `merge-strategies.md`, `conflict-resolution.md`
- **Scripts**: `validate-branch-name.sh` / `validate-branch-name.ps1`, `check-commit-message.sh` / `check-commit-message.ps1`, `clean-merged-branches.sh` / `clean-merged-branches.ps1`

### git-commit

Well-structured conventional commits that are atomic, reviewable, and meaningful.

- **Triggers**: git commit, commit message, conventional commit, commit code, save changes, amend commit, split commit
- **References**: `conventional-commits.md`, `commit-best-practices.md`
- **Scripts**: `smart-commit.sh` / `smart-commit.ps1`

### git-hooks

Git hook automation for code quality enforcement in Java/Maven projects.

- **Triggers**: git hooks, pre-commit, commit-msg, pre-push, checkstyle, spotless, maven hook, githooks
- **References**: `hook-types.md`, `maven-quality-setup.md`
- **Scripts**: `install-hooks.sh` / `install-hooks.ps1`

### github-pr-review

Pull request lifecycle management — create, describe, review, and merge.

- **Triggers**: pull request, PR, create PR, review PR, PR description, write PR, improve PR, summarize changes, code review, PR review
- **References**: `pr-description-guide.md`, `pr-enhancement-guide.md`, `pr-size-guidelines.md`, `review-checklist.md`, `review-feedback-guide.md`
- **Scripts**: `pr-description-generator.sh` / `pr-description-generator.ps1`

### github-automation

GitHub Actions workflows, branch protection, CODEOWNERS, and repository automation.

- **Triggers**: github actions, CI/CD, workflow, branch protection, CODEOWNERS, automation, github action, pipeline, continuous integration
- **References**: `actions-patterns.md`, `branch-protection.md`, `codeowners-guide.md`
- **Scripts**: `setup-branch-protection.sh` / `setup-branch-protection.ps1`

### changelog-release

Changelog generation, semantic versioning, and release pipeline automation.

- **Triggers**: changelog, release, version bump, semantic versioning, release notes, tag, publish
- **References**: `changelog-format.md`, `release-workflow.md`, `semantic-versioning.md`
- **Scripts**: `generate-changelog.sh` / `generate-changelog.ps1`

---

## Documentation / Review (5 skills)

### java-documentation

Java documentation using Javadoc and project documentation best practices — coverage reports, generation patterns, templates.

- **Triggers**: javadoc, documentation, package-info, module-info, README, API docs
- **References**: `documentation-guidelines.md`, `coverage-reports.md`, `doc-generation-patterns.md`, `documentation-templates.md`

### java-code-review

Java-specific code reviews — coding standards, design quality, testing, security, and performance using manual inspection and automated tools.

- **Triggers**: java review, java code review, java PR, checkstyle, spotbugs, PMD, static analysis, java audit
- **References**: `java-style-guide.md`, `java-review-checklist.md`, `clean-code-checklist.md`, `review-culture-guide.md`, `systematic-review-checklist.md`, `security-review-checklist.md`
- **Scripts**: `run-checkstyle.sh` / `run-checkstyle.ps1`, `run-spotbugs.sh` / `run-spotbugs.ps1`

### code-reviewer

Thorough, constructive code reviews that improve quality and share knowledge — structured reports, feedback patterns.

- **Triggers**: code review, PR review, pull request, review code, code quality, audit, security review
- **References**: `review-checklist.md`, `common-issues.md`, `feedback-examples.md`, `fix-verification.md`, `receiving-feedback.md`, `report-template.md`, `spec-compliance.md`

### code-refactoring

SOLID-guided refactoring and tech debt management — extract method, modernization, code smell remediation.

- **Triggers**: refactor, tech debt, code smell, clean code, SOLID, extract method, dead code, legacy, simplify, modernize
- **References**: `refactoring-patterns.md`, `tech-debt-management.md`

### dependency-audit

Java dependency auditing for vulnerabilities, license compliance, freshness, and supply chain risks.

- **Triggers**: dependency audit, CVE, vulnerability, OWASP dependency check, outdated dependencies, license, supply chain, dependency conflict, dependency tree
- **References**: `dependency-audit-guide.md`

---

## Other (5 skills)

### error-debugging

Systematic Java application debugging using structured analysis and proven strategies.

- **Triggers**: debug, error, exception, stack trace, thread dump, memory leak, OutOfMemoryError, deadlock, production incident, NullPointerException
- **References**: `debugging-strategies.md`, `error-patterns.md`, `incident-response-guide.md`

### java-observability

Logging and observability patterns for production Java applications — SLF4J, MDC, structured logging, metrics, tracing.

- **Triggers**: logging, observability, SLF4J, MDC, structured logging, metrics, tracing, OpenTelemetry, health check, monitoring
- **References**: `logging-guidelines.md`, `structured-logging-patterns.md`

### java-performance

Performance profiling and optimization — JMeter, JFR, memory analysis, CPU hotspots, load testing.

- **Triggers**: performance, profiling, JMeter, JFR, memory, CPU, hotspot, benchmark, load test, throughput, latency, GC
- **References**: `profiling-detect.md`, `profiling-analyze.md`, `profiling-refactor.md`, `profiling-verify.md`, `jmeter-guidelines.md`
- **Scripts**: `run-profiler.sh` / `run-profiler.ps1`

### agile-workflow

Agile artifacts — epics, features, and user stories with Gherkin acceptance criteria.

- **Triggers**: epic, feature, user story, acceptance criteria, Gherkin, BDD, agile, INVEST, story splitting
- **References**: `epic-template.md`, `feature-template.md`, `user-story-template.md`

### project-planning

Structured implementation plans, sprint management, and work organization using Cursor Plan mode and GitHub issues.

- **Triggers**: plan, implementation plan, cursor plan mode, sprint planning, estimation, backlog, GitHub issues, specification
- **References**: `plan-mode-template.md`, `github-issues-workflow.md`
