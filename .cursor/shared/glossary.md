# Glossary

## Git Terms

| Term | Definition |
|------|-----------|
| **Branch** | A lightweight movable pointer to a commit, representing an independent line of development |
| **Cherry-pick** | Apply changes from a specific commit onto the current branch |
| **Conventional Commits** | A commit message specification that uses structured types (feat, fix, etc.) |
| **Fast-forward** | A merge where the branch pointer moves forward without creating a merge commit |
| **Force-with-lease** | A safer alternative to `--force` that prevents overwriting others' work |
| **HEAD** | A pointer to the current branch reference or commit |
| **Rebase** | Replay commits on top of another branch to create linear history |
| **Reflog** | A log of all reference updates (branch tips, HEAD) for recovery purposes |
| **SemVer** | Semantic Versioning: MAJOR.MINOR.PATCH version numbering |
| **Squash merge** | Combine all branch commits into a single commit when merging |
| **Stash** | Temporarily save uncommitted changes without committing |
| **Tag** | A named reference to a specific commit, typically used for releases |
| **Trunk-based development** | A branching strategy where all developers work on short-lived branches off `main` |
| **Worktree** | An additional working directory attached to a repository for parallel development |

## GitHub Terms

| Term | Definition |
|------|-----------|
| **Action** | An automated workflow triggered by GitHub events |
| **CODEOWNERS** | A file that defines who is automatically requested for review on PRs |
| **Draft PR** | A pull request marked as work-in-progress, not ready for review |
| **gh** | The GitHub CLI tool for managing repos, PRs, issues from the terminal |
| **Ruleset** | A flexible set of branch/tag protection rules that can target multiple branches |
| **Status check** | A CI/CD check that must pass before a PR can be merged |
| **Workflow** | A YAML-defined automation in `.github/workflows/` |

## Code Review Terms

| Term | Definition |
|------|-----------|
| **Bikeshedding** | Spending disproportionate time debating trivial details |
| **LGTM** | "Looks Good To Me" -- informal approval |
| **Nit** | A trivial style preference that does not block merging |
| **Rubber-stamping** | Approving a PR without actually reviewing the code |
| **Spec compliance** | Verifying that code implements the requirements correctly |

## Java Terms

| Term | Definition |
|------|-----------|
| **BOM** | Bill of Materials -- a POM that centralizes dependency versions for consistent multi-module projects |
| **CompletableFuture** | Java's primary API for composing asynchronous operations without blocking |
| **DI** | Dependency Injection -- providing dependencies via constructor rather than creating them internally |
| **DTO** | Data Transfer Object -- a simple object for transferring data across boundaries (often a `record`) |
| **GraalVM Native Image** | Ahead-of-time compiled Java application with fast startup and low memory footprint |
| **JaCoCo** | Java Code Coverage library used to measure test coverage |
| **Jakarta EE** | The successor to Java EE, using the `jakarta.*` namespace |
| **JSpecify** | A set of annotations (`@NullMarked`, `@Nullable`) for standardized null safety across Java tools |
| **Loom** | Project Loom -- the OpenJDK initiative that delivered virtual threads in Java 21 |
| **Maven Wrapper** | A script (`mvnw`) that ensures a project uses a specific Maven version without global install |
| **Record** | An immutable data class (Java 16+) that auto-generates constructor, accessors, `equals`, `hashCode`, `toString` |
| **Sealed class** | A class that restricts which other classes may extend it (Java 17+), enabling exhaustive pattern matching |
| **ScopedValue** | A carrier for immutable data shared across tasks within a dynamic scope, preferred over `ThreadLocal` with virtual threads |
| **SOLID** | Five design principles: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion |
| **Testcontainers** | A library that provides lightweight, throwaway Docker containers for integration testing |
| **Value object** | A small immutable type that represents a domain concept (e.g., `EmailAddress`, `Money`) -- often a `record` |
| **Aggregate root** | The entity that controls access to a cluster of domain objects, enforcing invariants across the aggregate boundary |
| **ArchUnit** | A library for checking Java architecture rules (layer dependencies, naming conventions, cycle detection) in unit tests |
| **Flyway** | A database migration tool that applies versioned SQL scripts to evolve schemas in a controlled, repeatable way |
| **Lombok** | A Java annotation processor that generates boilerplate code (constructors, getters, loggers) at compile time; version 1.18.44+ for Spring Boot 4 |
| **OpenAPI** | A specification (formerly Swagger) for describing REST APIs in YAML/JSON, enabling code generation and documentation |
| **OpenRewrite** | An automated refactoring framework that applies recipes for Java/Spring migrations, style fixes, and dependency upgrades |
| **PECS** | "Producer Extends, Consumer Super" -- the wildcard guideline for generic collections (`? extends T` for reading, `? super T` for writing) |
| **RFC 9457** | The IETF standard for HTTP Problem Details, defining a JSON format (`type`, `title`, `status`, `detail`) for API error responses |
| **Virtual thread** | A lightweight thread (Java 21+) managed by the JVM, ideal for I/O-bound workloads at massive scale |

## Spring Terms

| Term | Definition |
|------|-----------|
| **Auto-configuration** | Spring Boot's mechanism to automatically configure beans based on classpath and properties |
| **Bean** | An object managed by the Spring IoC container |
| **ConfigurationProperties** | Type-safe configuration binding from `application.yml` / `application.properties` to a Java class |
| **Problem Details (RFC 9457)** | A standard JSON format for HTTP API error responses, natively supported in Spring Framework 7 |
| **Profile** | A named configuration set (`@Profile("dev")`) activated by environment to vary behavior |
| **SecurityFilterChain** | The Spring Security mechanism for defining HTTP security rules (replaces `WebSecurityConfigurerAdapter`) |
| **Slice test** | A focused Spring test that loads only a slice of the application context (`@WebMvcTest`, `@DataJdbcTest`, `@DataJpaTest`) |
| **Spring Data JDBC** | A simpler alternative to JPA for JDBC-based persistence with domain-driven design support |
| **Starter** | A Spring Boot dependency that bundles related libraries and auto-configuration (`spring-boot-starter-web`) |

| **Actuator** | Spring Boot module providing production-ready management endpoints (health, metrics, info) |
| **Aspect** | A modularization of cross-cutting concerns (logging, metrics, security) using Spring AOP `@Aspect` |
| **Cache eviction** | Removing stale entries from a cache, triggered by data changes (`@CacheEvict`) or TTL expiry |
| **Circuit breaker** | A resilience pattern that stops calling a failing dependency after a threshold, allowing recovery |
| **DataLoader** | A batching mechanism in GraphQL that groups individual field loads into a single batch query (N+1 prevention) |
| **GraphQL** | A query language for APIs that lets clients request exactly the data they need |
| **HATEOAS** | Hypermedia As The Engine Of Application State; REST responses include links to available actions |
| **Hibernate Validator** | The reference implementation of Jakarta Bean Validation; provides constraint annotations |
| **Idempotency** | The property that an operation produces the same result regardless of how many times it is executed |
| **MapStruct** | A compile-time code generator for type-safe Java bean mappings |
| **Micrometer** | A metrics facade for JVM-based applications, providing Counter, Timer, Gauge, and more |
| **Redis** | An in-memory data store used for caching, session management, rate limiting, and pub/sub |
| **Retry** | Automatically re-executing a failed operation with backoff, for transient failures only |
| **ScopedValue** | Java 21 preview feature for sharing immutable data within a thread or virtual thread scope |
| **Spring AOP** | Spring's proxy-based Aspect-Oriented Programming support for cross-cutting concerns |
| **Dirty checking** | Hibernate's mechanism of comparing managed entity state against a snapshot to auto-generate UPDATE SQL at flush time |
| **EntityManager** | The JPA interface for interacting with the persistence context; manages entity lifecycle (persist, merge, detach, flush) |
| **Flush mode** | Controls when Hibernate synchronizes persistence context changes to the database (AUTO, COMMIT, MANUAL) |
| **Hibernate Envers** | Hibernate module that automatically audits entity changes by writing revision records to `_AUD` tables |
| **JPQL** | Java Persistence Query Language; an object-oriented query language operating on entities rather than tables |
| **Optimistic locking** | Concurrency control using a `@Version` field; detects conflicts at commit time without database-level locks |
| **Persistence context** | The set of managed entity instances tracked by an `EntityManager` within a transaction (the L1 cache) |
| **Second-level cache (L2)** | A shared, cross-session cache in Hibernate that stores entity state by ID to reduce database reads |

## Build Terms

| Term | Definition |
|------|-----------|
| **BOM import** | Importing a Bill of Materials POM in `<dependencyManagement>` to centralize versions |
| **Dependency locking** | Pinning resolved dependency versions to ensure reproducible builds |
| **Enforcer plugin** | Maven plugin that enforces build-time constraints (Java version, no snapshots, etc.) |
| **Failsafe** | Maven plugin for running integration tests (suffix `*IT.java`) |
| **Surefire** | Maven plugin for running unit tests (suffix `*Test.java`) |
| **Version catalog** | Gradle's `libs.versions.toml` for centralizing dependency declarations |

## .cursor Terms

| Term | Definition |
|------|-----------|
| **Rule (.mdc)** | A policy document auto-loaded by Cursor based on file globs |
| **Skill (SKILL.md)** | An on-demand capability invoked by the agent when triggered |
| **Agent** | A specialized subagent definition with scoped responsibilities and tools |
| **Reference** | Supporting documentation within a skill's `references/` folder |
