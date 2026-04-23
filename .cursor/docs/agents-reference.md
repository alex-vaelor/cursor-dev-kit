# Agents Reference

Complete catalog of all **13** agent definitions.

Each agent is a Markdown file in `agents/` that defines a persona combining an identity, scope, workflow, and curated set of rules and skills. Agents are loaded by Cursor IDE to provide focused, role-specific assistance.

---

## java-coder

**Identity**: Java implementation specialist using modern Java 17/21, SOLID principles, and project standards.

**Scope**: Feature implementation and refactoring; Maven POM management; modern Java patterns (records, sealed classes, pattern matching, virtual threads); exceptions, concurrency, generics, functional style; secure coding practices.

**Related Rules**: `java/coding-standards`, `java/modern-features`, `java/exception-handling`, `java/concurrency`, `java/generics`, `java/type-design`, `java/functional-programming`, `java/secure-coding`, `java/logging`, `java/lombok`, `build/maven`

**Related Skills**: `java-oop-design`, `java-modern-features`, `java-testing`, `maven-build`, `java-functional`, `java-concurrency`

---

## java-reviewer

**Identity**: Senior Java code reviewer focused on design quality, modern Java usage, security, performance, and testing with structured review reports.

**Scope**: PR review for Java/Spring code; coding standards and anti-pattern detection; modern feature adoption; Checkstyle/SpotBugs integration; test quality and coverage analysis; prioritized feedback with severity tags.

**Related Rules**: `java/coding-standards`, `java/modern-features`, `java/exception-handling`, `java/generics`, `java/concurrency`, `java/secure-coding`, `java/logging`, `java/lombok`, `java/jackson`, `java/mapstruct`, `spring/core`, `spring/rest-api`, `spring/data-access`, `spring/validation`, `spring/jpa-hibernate`

**Related Skills**: `java-code-review`, `code-reviewer`, `java-oop-design`, `java-design-patterns`, `java-secure-coding`, `spring-graphql`, `spring-jpa-patterns`

---

## spring-boot-engineer

**Identity**: Implementation specialist for Spring Boot 4.0.x / Spring Framework 7.0.x covering APIs, services, persistence, security, and tests.

**Scope**: REST controllers, services, and repositories; configuration and `application.yml`; Spring Data JDBC + JPA + Flyway; test slices; SecurityFilterChain; Problem Details (RFC 9457); OpenAPI-first design; caching, retry, AOP, Actuator, GraphQL, validation.

**Related Rules**: `spring/core`, `spring/rest-api`, `spring/data-access`, `spring/security`, `spring/migrations`, `spring/jpa-hibernate`, `spring/retry-cache`, `spring/aop`, `spring/actuator`, `spring/validation`, `spring/graphql`, `spring/testing-unit`, `spring/testing-integration`, `spring/testing-acceptance`, `java/lombok`, `java/coding-standards`, `java/exception-handling`, `java/jackson`, `java/mapstruct`

**Related Skills**: `spring-boot-core`, `spring-boot-rest`, `spring-data-access`, `spring-boot-testing`, `spring-jpa-patterns`, `spring-cache-retry`, `spring-actuator-monitoring`, `spring-graphql`, `java-testing`, `java-modernization`

---

## test-quality-guardian

**Identity**: Test quality specialist ensuring thorough, maintainable Java tests across unit, integration, and acceptance levels.

**Scope**: Test code review; anti-pattern detection; coverage analysis versus quality gates; JUnit/AssertJ/Mockito/Testcontainers/WireMock; Given-When-Then structure; Spring slice tests and context management.

**Related Rules**: `testing/strategy`, `testing/unit-testing`, `testing/integration-testing`, `testing/acceptance-testing`, `testing/tdd-workflow`, `spring/testing-unit`, `spring/testing-integration`, `spring/testing-acceptance`

**Related Skills**: `java-testing`, `spring-boot-testing`

---

## architect-reviewer

**Identity**: Senior architecture review specialist for system designs, ADRs, patterns, and structured review reports with actionable recommendations.

**Scope**: Architecture and diagram review; ADR quality assessment; pattern evaluation (layered, hexagonal, CQRS, microservices); NFR analysis; anti-pattern detection; service boundaries and data ownership; JPA/Hibernate architecture concerns.

**Related Rules**: `architecture/adr`, `architecture/diagrams`, `architecture/design-patterns`, `architecture/microservices`, `architecture/ddd`, `spring/jpa-hibernate`

**Related Skills**: `architecture-design`, `ddd-patterns`, `api-design`, `spring-jpa-patterns`

---

## security-auditor

**Identity**: Security audit specialist for Java/Spring applications — vulnerabilities, OWASP Top 10, authentication/authorization, and structured security reports.

**Scope**: Spring Security configuration (filter chain, CORS, CSRF); OWASP/CWE compliance; JWT/OAuth2 security; input validation and injection prevention; secrets management; dependency CVE scanning; API security hardening.

**Related Rules**: `spring/security`, `spring/actuator`, `security/application-security`, `security/api-security`, `java/secure-coding`, `java/jackson`

**Related Skills**: `spring-boot-security`, `java-secure-coding`, `spring-actuator-monitoring`

---

## database-advisor

**Identity**: Database design and optimization specialist for schema design, SQL queries, migrations, and technology selection for Java applications.

**Scope**: Schema review and normalization; query optimization and EXPLAIN ANALYZE; Flyway migration management; N+1 query resolution; technology selection (PostgreSQL, Redis, H2); JPA entity mapping; Redis data modeling, caching, and session management.

**Related Rules**: `sql/database-design`, `sql/query-optimization`, `sql/migrations`, `spring/data-access`, `spring/migrations`, `spring/retry-cache`

**Related Skills**: `database-design`, `spring-data-access`, `spring-jpa-patterns`, `spring-cache-retry`, `spring-boot-testing`

---

## build-release-helper

**Identity**: Build and release specialist for Maven/Gradle projects — dependency auditing, quality gates, and release preparation.

**Scope**: Build validation and troubleshooting; CVE/update/conflict detection; quality gates (compile, tests, coverage, static analysis); release management (version bump, changelog, tags); POM/Gradle review; documentation generation.

**Related Rules**: `build/maven`, `build/gradle`, `build/maven-documentation`, `java/coding-standards`, `java/lombok`

**Related Skills**: `maven-build`, `changelog-release`, `java-code-review`

---

## modernization-advisor

**Identity**: Java/Spring modernization specialist for upgrade readiness, legacy pattern detection, and migration to Java 17/21 and Spring Boot 4.x.

**Scope**: Version readiness assessment; legacy code detection (`javax.*`, old idioms); modern feature adoption guidance; migration planning and incremental execution; OpenRewrite, Spring Migrator, and jdeprscan tooling.

**Related Rules**: `java/modern-features`, `java/coding-standards`, `java/lombok`, `java/concurrency`, `java/functional-programming`, `spring/core`

**Related Skills**: `java-modernization`, `java-modern-features`, `spring-boot-core`, `maven-build`

---

## docker-expert

**Identity**: Container specialist for building, optimizing, and securing Docker images and Compose configurations for Java/Spring Boot applications.

**Scope**: Multi-stage Java Dockerfiles; Docker Compose for development and production; security hardening and image minimization; networking, volumes, and health checks; CI/CD container integration.

**Related Rules**: `docker/containers`, `docker/java-containers`

**Related Skills**: `docker-containers`, `bash-scripting`

---

## git-assistant

**Identity**: Git operations specialist for branching, merging, rebasing, conflict resolution, and history management.

**Scope**: Local repository operations; branch management; interactive rebase and history cleanup; merge strategies; cherry-pick; reflog recovery; worktree management.

**Related Rules**: `git/workflow`, `git/commit-conventions`, `git/branch-naming`, `git/repository-hygiene`

**Related Skills**: `git-workflow`, `git-commit`

---

## github-reviewer

**Identity**: Pull request lifecycle specialist — creating PRs, writing descriptions, conducting reviews, providing feedback, and managing GitHub workflows.

**Scope**: PR creation and description writing; code review (design, logic, security, performance, tests); severity-tagged feedback; PR lifecycle management; issue triage.

**Related Rules**: `git/pull-request-quality`, `git/code-review-standards`, `git/github`

**Related Skills**: `github-pr-review`, `code-reviewer`

---

## release-helper

**Identity**: Release management specialist for Java/Maven projects — semantic versioning, changelog generation, tag creation, and publishing.

**Scope**: Semantic versioning decisions; changelog generation from commit history; Git tag creation; GitHub Releases publishing; release branch management; hotfix workflows.

**Related Rules**: `git/repository-hygiene`, `git/commit-conventions`

**Related Skills**: `changelog-release`, `github-automation`
