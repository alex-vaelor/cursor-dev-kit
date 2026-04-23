# Prompt Examples

Copy-paste-ready prompts for using this `.cursor/` configuration in Cursor IDE. Examples range from simple keyword-triggered prompts to advanced multi-reference workflows.

---

## 1. How Referencing Works in Cursor

Cursor uses `@` syntax to attach files and folders as context to your prompt. You can reference any file in the workspace:

| Reference type | Syntax | What it provides |
|----------------|--------|------------------|
| Agent | `@.cursor/agents/java-reviewer.md` | Loads a persona with identity, scope, and curated rules/skills |
| Skill | `@.cursor/skills/spring-jpa-patterns/SKILL.md` | Loads a skill entry point with triggers, key patterns, and references |
| Rule | `@.cursor/rules/spring/jpa-hibernate.mdc` | Loads a specific standards/conventions document |
| Reference guide | `@.cursor/skills/java-testing/references/jacoco-coverage.md` | Loads a deep-dive guide on a specific topic |
| Template | `@.cursor/templates/pull-request-template-java.md` | Loads a template for the AI to fill out |
| Shared resource | `@.cursor/shared/supported-version-matrix.md` | Loads cross-cutting standards (versions, conventions, glossary) |

**You don't always need `@` references.** Many skills activate automatically when your prompt contains trigger keywords (e.g. "unit test", "JPA entity", "Docker"). Use explicit `@` references when you want to guarantee a specific resource is loaded or combine multiple resources.

---

## 2. Implicit Prompts (Keyword-Triggered)

These prompts activate skills automatically through trigger keywords -- no `@` references needed.

### Java Coding

```
Refactor this class to use a sealed interface with records instead of the
inheritance hierarchy. Use pattern matching in the switch.
```

```
This method has 8 parameters. Redesign it using a builder pattern or a
parameter object record.
```

```
Convert this code to use virtual threads instead of the cached thread pool.
Explain the trade-offs.
```

```
Review this stream pipeline for correctness. Are there any side effects,
ordering issues, or cases where a simple loop would be clearer?
```

### Spring Boot

```
Create a REST endpoint for managing Orders. Include DTOs as records,
validation with @Valid, proper HTTP status codes, and Problem Details
error handling (RFC 9457).
```

```
Add @Cacheable to the ProductService.findById method with a TTL of 10 minutes.
Use Caffeine as the cache backend. Show the configuration in application.yml.
```

```
Implement a SecurityFilterChain that uses JWT Bearer tokens with
Spring Security's OAuth2 Resource Server. Include role-based access control
with @PreAuthorize.
```

```
Add a @Retryable annotation to this external API call with exponential backoff.
Include a @Recover fallback method.
```

### Testing

```
Write unit tests for this OrderService class using JUnit 5 and Mockito.
Follow Given-When-Then structure and test edge cases.
```

```
Create an integration test for this repository using @DataJpaTest with
Testcontainers (PostgreSQL). Verify the custom query method.
```

```
I want to apply TDD to build a discount calculator. Start with the
first failing test for the simplest case.
```

```
Review my test class for anti-patterns: are there any flaky tests,
over-mocking, logic in tests, or missing assertions?
```

### Database

```
Design a normalized schema for an e-commerce system with products,
categories, orders, and order items. Include indexes and constraints.
```

```
This query is slow. Run EXPLAIN ANALYZE and suggest optimizations.
Check for missing indexes and N+1 problems.
```

```
Create a Flyway migration to add a new 'status' column to the orders table.
Follow zero-downtime migration patterns.
```

### Git / GitHub

```
Write a conventional commit message for the staged changes. Follow the
format: type(scope): Subject
```

```
Create a PR description for the current branch. Summarize the changes,
list affected files by category, and assess risk level.
```

```
Clean up my branch: squash fixup commits, reword the initial commit,
and rebase onto main.
```

### Architecture

```
Write an ADR for choosing between PostgreSQL and MongoDB for our
event storage. Evaluate consistency, query patterns, and scalability.
```

```
Design the bounded contexts for a food delivery system. Identify the
aggregates, entities, value objects, and domain events for each context.
```

```
Review the current architecture for single points of failure.
Suggest resilience improvements with circuit breakers and retries.
```

### DevOps

```
Write a multi-stage Dockerfile for this Spring Boot application.
Use Eclipse Temurin, minimize image size, and run as non-root.
```

```
Our Maven build is slow. Audit the POM for unnecessary plugins,
duplicate dependencies, and missing parallelism options.
```

```
Profile this application with JFR. Show me how to attach to the running
process and analyze the recording for CPU hotspots.
```

---

## 3. Direct Agent References

Use `@` to invoke a specific agent persona. The agent brings its full identity, scope, related rules, and skills.

### Java Reviewer

```
@.cursor/agents/java-reviewer.md

Review this PR for coding standards, design quality, modern Java usage,
and security. Produce a structured report with severity tags.
```

### Spring Boot Engineer

```
@.cursor/agents/spring-boot-engineer.md

Implement a CRUD REST API for the Customer entity. Include:
- Controller with DTOs as records and @Valid
- Service layer with @Transactional
- Spring Data JPA repository
- Unit test for the service, integration test for the controller
```

### Security Auditor

```
@.cursor/agents/security-auditor.md

Audit the SecurityFilterChain and all controller endpoints for:
- OWASP Top 10 compliance
- JWT token validation
- Input sanitization
- Missing authorization checks
```

### Database Advisor

```
@.cursor/agents/database-advisor.md

Review the JPA entity mappings and repository queries in this module.
Identify N+1 problems, inefficient fetch strategies, and missing indexes.
Suggest fixes with code examples.
```

### Architect Reviewer

```
@.cursor/agents/architect-reviewer.md

Review the architecture of this module. Check for:
- Layering violations
- Proper aggregate boundaries
- Missing ADRs for key decisions
- Non-functional requirement coverage
```

### Test Quality Guardian

```
@.cursor/agents/test-quality-guardian.md

Audit the test suite for this module. Check coverage gaps, flaky tests,
anti-patterns (e.g. testing implementation instead of behavior), and
missing integration tests for critical paths.
```

### Modernization Advisor

```
@.cursor/agents/modernization-advisor.md

Scan this codebase for legacy patterns. Create a prioritized migration plan
from Java 11 to Java 21 and from Spring Boot 2.x to Spring Boot 4.x.
Include OpenRewrite recipes where applicable.
```

### Build Release Helper

```
@.cursor/agents/build-release-helper.md

Audit the pom.xml for dependency issues: outdated versions, known CVEs,
unused dependencies, and missing BOM imports. Suggest fixes.
```

### Docker Expert

```
@.cursor/agents/docker-expert.md

Optimize the Dockerfile for this Spring Boot app. Reduce image size,
add health checks, configure JVM memory for containers, and create a
docker-compose.yml for local development with PostgreSQL and Redis.
```

### Git Assistant

```
@.cursor/agents/git-assistant.md

I accidentally committed to main. Help me move the last 3 commits to a
new feature branch and reset main to match origin.
```

### GitHub Reviewer

```
@.cursor/agents/github-reviewer.md

Write a detailed PR description for the current branch. Include a summary,
change table, testing checklist, risk assessment, and self-review checklist.
```

### Release Helper

```
@.cursor/agents/release-helper.md

Prepare a release from the current state of the develop branch. Determine
the version bump from commit history, generate the changelog, and create
the Git tag.
```

### Java Coder

```
@.cursor/agents/java-coder.md

Implement a Money value object as a record with currency and amount.
Include validation, arithmetic operations, and proper equals/hashCode.
Use BigDecimal for precision.
```

---

## 4. Direct Skill References

Use `@` to load a specific skill for deep, focused expertise on a topic.

### JPA / Hibernate

```
@.cursor/skills/spring-jpa-patterns/SKILL.md

This entity has a @OneToMany relationship that causes N+1 queries.
Show me how to fix it with @EntityGraph, JOIN FETCH, and @BatchSize.
Compare the trade-offs of each approach.
```

### Design Patterns

```
@.cursor/skills/java-design-patterns/SKILL.md

Implement the Strategy pattern for a payment processing system.
Use sealed interfaces and records for the strategies. Show how to
integrate with Spring's dependency injection.
```

### API Design

```
@.cursor/skills/api-design/SKILL.md

Design a REST API for a task management system. Define resources,
HTTP methods, status codes, pagination, filtering, and error responses.
Follow OpenAPI conventions.
```

### Caching and Retry

```
@.cursor/skills/spring-cache-retry/SKILL.md

Add caching to the ProductCatalogService. Cache product lookups by ID
and by category. Implement cache eviction when products are updated.
Configure Redis as the cache backend with per-key TTLs.
```

### GraphQL

```
@.cursor/skills/spring-graphql/SKILL.md

Create a GraphQL API for the existing Order and Product entities.
Include a schema file, query/mutation controllers, and a DataLoader
to prevent N+1 queries on the product -> reviews relationship.
```

### Spring Actuator / Monitoring

```
@.cursor/skills/spring-actuator-monitoring/SKILL.md

Set up production monitoring: expose health, metrics, and info endpoints.
Add a custom health indicator for the external payment gateway.
Create Micrometer counters for order placement and timers for API latency.
```

### DDD Patterns

```
@.cursor/skills/ddd-patterns/SKILL.md

Model the Order aggregate for an e-commerce bounded context. Define the
aggregate root, value objects (Money, Address), and domain events
(OrderPlaced, OrderCancelled). Show invariant enforcement.
```

### Database Design

```
@.cursor/skills/database-design/SKILL.md

Design a multi-tenant database schema using PostgreSQL Row-Level Security.
Show the tenant_id column strategy, RLS policies, and how to integrate
with Hibernate's TenantIdentifierResolver.
```

### Saga Patterns

```
@.cursor/skills/saga-patterns/SKILL.md

Implement an order fulfillment saga across Order, Payment, and Inventory
services. Use the choreography approach with Spring Application Events.
Include compensation logic for payment failure.
```

### Error Debugging

```
@.cursor/skills/error-debugging/SKILL.md

I'm getting a LazyInitializationException in production. Walk me through
a systematic debugging approach: reproduce, analyze the stack trace,
identify the root cause, and implement a fix.
```

### Code Refactoring

```
@.cursor/skills/code-refactoring/SKILL.md

This service class has 500 lines and 12 dependencies. Identify the code
smells, propose a refactoring plan using SOLID principles, and implement
the Extract Class and Extract Method refactorings.
```

### Dependency Audit

```
@.cursor/skills/dependency-audit/SKILL.md

Run a full dependency audit: check for known CVEs, outdated versions,
unused dependencies, and license conflicts. Prioritize findings by risk.
```

---

## 5. Direct Rule References

Use `@` to load a specific rule when you want the AI to enforce particular standards.

```
@.cursor/rules/java/coding-standards.mdc

Review this class against our Java coding standards. Check naming,
formatting, imports, and modern idiom usage.
```

```
@.cursor/rules/spring/validation.mdc

Add validation to this CreateOrderRequest DTO. Use Jakarta Bean
Validation annotations, custom validators for business rules, and
validation groups for create vs update.
```

```
@.cursor/rules/spring/jpa-hibernate.mdc

Review this JPA entity design. Check field access strategy, @Version
for optimistic locking, equals/hashCode implementation, and relationship
mapping conventions.
```

```
@.cursor/rules/java/concurrency.mdc

Review this concurrent code for thread safety issues. Check for proper
synchronization, use of concurrent collections, and whether virtual
threads are appropriate here.
```

```
@.cursor/rules/security/api-security.mdc

Audit this REST controller against the OWASP API Security Top 10.
Check authentication, authorization, rate limiting, input validation,
and CORS configuration.
```

```
@.cursor/rules/testing/unit-testing.mdc

Review these unit tests against our testing standards. Check for proper
isolation, meaningful assertions, test naming, and edge case coverage.
```

---

## 6. Referencing Specific Guides

Use `@` to load a deep-dive reference document when you need detailed guidance on a narrow topic.

```
@.cursor/skills/java-testing/references/jacoco-coverage.md

Configure JaCoCo for our multi-module Maven project. Set instruction
coverage threshold to 80%, exclude Lombok-generated code and MapStruct
mappers, and fail the build if coverage drops below the threshold.
```

```
@.cursor/skills/spring-jpa-patterns/references/hibernate-performance.md

Set up Hibernate second-level cache with Caffeine for our Product entity.
Configure cache regions, concurrency strategy, and query cache. Show
how to monitor cache hit rates with Micrometer.
```

```
@.cursor/skills/api-design/references/hateoas-guide.md

Add HATEOAS links to the OrderController responses. Use EntityModel,
WebMvcLinkBuilder, and a RepresentationModelAssembler. Include
self, collection, and related resource links.
```

```
@.cursor/skills/java-secure-coding/references/jwt-security-patterns.md

Implement JWT token refresh rotation. Show the token structure,
signing configuration, refresh endpoint, token revocation strategy,
and Spring Security integration.
```

```
@.cursor/skills/spring-jpa-patterns/references/hibernate-envers.md

Add audit history to the Order entity using Hibernate Envers. Configure
revision tables, query historical data, and set up Spring Data Envers
RevisionRepository for easy access.
```

```
@.cursor/skills/java-design-patterns/references/design-patterns-guide.md

I need to decouple event producers from consumers in my order processing
pipeline. Which GoF pattern fits best? Show the implementation with
modern Java features.
```

```
@.cursor/skills/architecture-design/references/architecture-principles.md

Evaluate whether our current module structure follows the Dependency Rule
from Clean Architecture. Identify any violations and suggest fixes.
```

```
@.cursor/skills/spring-jpa-patterns/references/entity-mapping-advanced.md

Model an Address as an @Embeddable value object used across Customer,
Order, and Warehouse entities. Show @AttributeOverride for column naming
and @ElementCollection for multiple addresses per entity.
```

---

## 7. Combining Multiple References

Power-user prompts that combine agents, skills, and rules for precise context.

### Agent + Skill -- Focused Review

```
@.cursor/agents/java-reviewer.md
@.cursor/skills/spring-jpa-patterns/SKILL.md

Review the JPA entity mappings and repository layer in this module.
Focus on entity design, relationship mapping, fetch strategies, and
query efficiency. Flag any N+1 issues.
```

### Agent + Rule -- Standards-Guided Implementation

```
@.cursor/agents/spring-boot-engineer.md
@.cursor/rules/spring/validation.mdc

Implement the CreateOrderRequest and UpdateOrderRequest DTOs with full
validation. Use validation groups to differentiate create vs update rules.
Add a custom cross-field validator for delivery date vs order date.
```

### Agent + Multiple Skills -- Cross-Cutting Task

```
@.cursor/agents/security-auditor.md
@.cursor/skills/spring-boot-security/SKILL.md
@.cursor/skills/api-design/SKILL.md

Audit the REST API layer for security issues. Check authentication,
authorization on each endpoint, rate limiting, CORS, input validation,
and error response information leakage.
```

### Two Skills -- Design + Implementation

```
@.cursor/skills/ddd-patterns/SKILL.md
@.cursor/skills/spring-jpa-patterns/SKILL.md

Design the Payment aggregate following DDD tactical patterns, then
implement it as JPA entities with proper mapping, lifecycle callbacks,
and domain events published via @DomainEvents.
```

### Agent + Specific Guide -- Deep Optimization

```
@.cursor/agents/database-advisor.md
@.cursor/skills/spring-jpa-patterns/references/hibernate-performance.md

Our product listing page is slow. Analyze the queries, set up L2 cache
for Product entities, optimize the pagination queries, and configure
batch fetching for the product -> images relationship.
```

### Rule + Guide -- Compliance Check

```
@.cursor/rules/security/api-security.mdc
@.cursor/skills/java-secure-coding/references/jwt-security-patterns.md

Verify that our JWT implementation follows the security rules. Check
algorithm selection, token lifetime, refresh rotation, claim validation,
and revocation handling.
```

---

## 8. Using Templates

Reference a template to have Cursor fill it out based on your current context.

### PR Description

```
@.cursor/templates/pull-request-template-java.md

Fill out this PR template for the current branch. Summarize the changes,
list affected files, complete the testing and quality checklists, and
assess the risk level.
```

### Architecture Decision Record

```
@.cursor/templates/adr-template.md

Write an ADR for the decision to use Redis as our caching layer instead
of Caffeine. Include context, decision drivers, evaluated options with
pros/cons, and consequences.
```

### Bug Report

```
@.cursor/templates/bug-report-template-java.md

Write a bug report for the issue: OrderService throws NullPointerException
when placing an order with a null shipping address. Include reproduction
steps, expected vs actual behavior, and environment details.
```

### Feature Request

```
@.cursor/templates/feature-request-template-java.md

Write a feature request for adding bulk order import via CSV upload.
Include the motivation, proposed API design, acceptance criteria, and
a suggested implementation approach.
```

### API Review

```
@.cursor/templates/api-review-template.md

Fill out an API review for the /api/v1/products endpoints. Cover resource
design, HTTP method usage, status codes, error handling, pagination,
and security.
```

---

## 9. Common End-to-End Workflows

Multi-step workflows showing how to chain prompts for a complete development cycle.

### New Spring Boot Feature

**Step 1 -- Plan:**
```
@.cursor/agents/architect-reviewer.md
@.cursor/skills/architecture-design/SKILL.md

I need to add an order notifications feature. Help me plan: which bounded
context does this belong to? What are the key entities and events?
Should it be synchronous or event-driven?
```

**Step 2 -- Implement:**
```
@.cursor/agents/spring-boot-engineer.md

Implement the NotificationService based on the plan. Include:
- Domain events (OrderPlaced, OrderShipped)
- Event listener with @TransactionalEventListener
- REST endpoint to query notification history
- Flyway migration for the notifications table
```

**Step 3 -- Test:**
```
@.cursor/agents/test-quality-guardian.md

Write tests for the notification feature:
- Unit tests for NotificationService with mocked event publisher
- Integration test with @SpringBootTest verifying end-to-end event flow
- Repository test with @DataJpaTest and Testcontainers
```

**Step 4 -- Review:**
```
@.cursor/agents/java-reviewer.md

Review the complete notification feature. Check code quality, design
patterns, exception handling, test coverage, and security.
```

**Step 5 -- PR:**
```
@.cursor/agents/github-reviewer.md
@.cursor/templates/pull-request-template-java.md

Create a PR for the notification feature. Generate a comprehensive
description using the Java PR template.
```

### Fix a Production Bug

**Step 1 -- Debug:**
```
@.cursor/skills/error-debugging/SKILL.md

We're seeing intermittent 500 errors on POST /api/orders. The stack trace
shows OptimisticLockException. Help me debug: analyze the trace, identify
the race condition, and find the root cause.
```

**Step 2 -- Fix:**
```
@.cursor/agents/spring-boot-engineer.md
@.cursor/rules/spring/jpa-hibernate.mdc

Implement the fix: add @Version for optimistic locking, implement retry
logic with @Retryable for the concurrent update case, and add a proper
error response for conflict situations.
```

**Step 3 -- Test:**
```
@.cursor/skills/java-testing/SKILL.md

Write a test that reproduces the race condition using two concurrent
threads updating the same order. Verify that the retry logic handles
the conflict correctly.
```

**Step 4 -- Commit:**
```
@.cursor/skills/git-commit/SKILL.md

Create a conventional commit for this bugfix. The commit should reference
the issue number and explain the root cause in the body.
```

### Modernize Legacy Code

**Step 1 -- Audit:**
```
@.cursor/agents/modernization-advisor.md

Scan this module for legacy patterns: Java 8 idioms, javax.* imports,
deprecated APIs, raw types, and old Spring patterns. Produce a prioritized
list of changes needed.
```

**Step 2 -- Plan:**
```
@.cursor/skills/java-modernization/SKILL.md

Create an incremental migration plan. I want to modernize in small,
safe steps. Prioritize: javax -> jakarta namespace, then records for DTOs,
then pattern matching, then virtual threads where appropriate.
```

**Step 3 -- Refactor:**
```
@.cursor/agents/java-coder.md
@.cursor/skills/java-modern-features/SKILL.md

Apply the first batch of modernizations: convert data-carrier classes to
records, replace instanceof chains with pattern matching, and use switch
expressions where appropriate.
```

**Step 4 -- Verify:**
```
@.cursor/agents/test-quality-guardian.md

Run the full test suite and verify that the modernization didn't break
anything. Check for any tests that need updating to work with the new
record types.
```

---

## Tips

- **Start simple.** Keyword-triggered prompts (Section 2) handle most daily tasks without any `@` references.
- **Use agents for roles.** When you want a specific persona (reviewer, engineer, auditor), reference the agent.
- **Use skills for topics.** When you need deep expertise on a narrow topic (JPA, caching, GraphQL), reference the skill.
- **Use rules for standards.** When you want the AI to enforce specific conventions, reference the rule.
- **Use guides for depth.** When you need detailed knowledge on a subtopic (L2 cache, JWT patterns, Envers), reference the specific guide file.
- **Combine for precision.** The most effective prompts combine an agent (who) + a skill or rule (what standards) + your specific question (context).
- **Reference the version matrix** (`@.cursor/shared/supported-version-matrix.md`) when asking about dependency versions to keep answers aligned with your project's baselines.
