---
name: spring-boot-testing
description: "Use when writing or reviewing Spring Boot tests -- including slice tests (@WebMvcTest, @DataJdbcTest, @DataJpaTest), MockMvc, @MockitoBean, Testcontainers integration, WireMock, and Spring-specific testing patterns across unit, integration, and acceptance levels."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: spring test, WebMvcTest, DataJdbcTest, DataJpaTest, SpringBootTest, MockitoBean, testcontainers, WireMock, slice test
  role: specialist
  scope: spring-boot-testing
  original-author: Juan Antonio Breña Moral
  related-skills: java-testing, spring-boot-core
---

# Spring Boot Testing

Write and review Spring Boot tests using slice tests, Testcontainers, and WireMock. Aligned with Spring Boot 4.0.x.

## When to Use This Skill

- Write or review Spring Boot slice tests (controller, repository)
- Set up integration tests with Testcontainers
- Stub external services with WireMock
- Configure Spring test context and profiles
- Review Spring-specific testing anti-patterns

## Coverage

### Unit Tests (Slice)
- `@WebMvcTest` for controller tests with MockMvc
- `@DataJdbcTest` for Spring Data JDBC repository tests
- `@DataJpaTest` for Spring Data JPA repository tests (auto-configures embedded DB, JPA, Hibernate)
- `@JsonTest` for serialization tests
- `@MockitoBean` / `@MockitoSpyBean` (Spring Boot 4.x)

### Integration Tests
- `@SpringBootTest(webEnvironment = RANDOM_PORT)` for full-stack tests
- Testcontainers with `@ServiceConnection` for database containers
- WireMock for external HTTP service stubs
- `@DynamicPropertySource` for custom property injection

### Acceptance Tests
- End-to-end API testing with WebTestClient or REST Assured
- Feature-based test organization
- Test data management and cleanup strategies

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Spring unit testing | `references/unit-testing.md` | When writing slice tests |
| Spring integration testing | `references/integration-testing.md` | When writing Testcontainers tests |
| Spring acceptance testing | `references/acceptance-testing.md` | When writing E2E tests |
| Test database patterns | `references/test-database-patterns.md` | When choosing H2 vs Testcontainers |

## Related Rules

- `rules/spring/testing-unit.mdc` -- unit testing rules
- `rules/spring/testing-integration.mdc` -- integration testing rules
- `rules/spring/testing-acceptance.mdc` -- acceptance testing rules
