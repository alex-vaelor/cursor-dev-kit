---
name: java-testing
description: "Use when reviewing, improving, or writing Java tests -- including testing strategy, JUnit 5/6, AssertJ, Mockito, parameterized tests, integration testing with Testcontainers, acceptance testing, test independence, coverage guidance, and testing anti-patterns."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: test, junit, mockito, assertj, unit test, integration test, acceptance test, coverage, TDD, parameterized test, testcontainers
  role: specialist
  scope: java-testing
  original-author: Juan Antonio Breña Moral
  related-skills: spring-boot-testing, java-concurrency
---

# Java Testing

Review and improve Java tests using modern JUnit, AssertJ, and Mockito best practices across unit, integration, and acceptance testing.

## When to Use This Skill

- Review or write Java unit tests
- Review or write integration tests with Testcontainers
- Review or write acceptance tests
- Define testing strategy for a Java project
- Identify and fix testing anti-patterns
- Improve test coverage and quality

## Coverage

### Testing Strategy
- Test pyramid: unit > integration > acceptance
- What to test at each level
- Coverage targets and exclusions

### Unit Testing
- JUnit 5/6 annotations: `@Test`, `@BeforeEach`, `@DisplayName`, `@Nested`, `@ParameterizedTest`
- AssertJ fluent assertions
- Given-When-Then structure, descriptive naming
- Mockito: `@Mock`, `@InjectMocks`, `MockitoExtension`
- JaCoCo coverage guidance
- Testing anti-patterns: reflection, shared state, testing implementation details

### Integration Testing
- Testcontainers for database and service containers
- Spring `@SpringBootTest` integration patterns
- WireMock for HTTP service stubs
- Test data management and cleanup

### Acceptance Testing
- End-to-end API testing with REST Assured
- Contract testing patterns
- Test environment management

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements
- **BEFORE APPLYING**: Read the appropriate reference for the testing level

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Testing strategy overview | `references/testing-strategy.md` | When defining or reviewing test strategy |
| Unit testing guidelines | `references/unit-testing.md` | When reviewing or writing unit tests |
| Integration testing guidelines | `references/integration-testing.md` | When reviewing or writing integration tests |
| Acceptance testing guidelines | `references/acceptance-testing.md` | When reviewing or writing acceptance tests |
| WireMock guidelines | `references/wiremock-guidelines.md` | When stubbing HTTP services in tests |
| ArchUnit guidelines | `references/archunit-guidelines.md` | When enforcing architecture rules in tests |
| JaCoCo coverage guide | `references/jacoco-coverage.md` | When configuring coverage thresholds and exclusions |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/run-tests.sh` | Run the full test suite with coverage |
| `scripts/coverage-report.sh` | Generate JaCoCo coverage report |

## Related Rules

- `rules/testing/strategy.mdc` -- testing strategy
- `rules/testing/unit-testing.mdc` -- unit testing rules
- `rules/testing/integration-testing.mdc` -- integration testing rules
- `rules/testing/acceptance-testing.mdc` -- acceptance testing rules
- `rules/testing/tdd-workflow.mdc` -- TDD workflow
- `rules/spring/testing-unit.mdc` -- Spring unit tests
- `rules/spring/testing-integration.mdc` -- Spring integration tests
- `rules/spring/testing-acceptance.mdc` -- Spring acceptance tests
