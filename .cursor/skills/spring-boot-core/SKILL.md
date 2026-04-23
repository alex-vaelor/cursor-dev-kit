---
name: spring-boot-core
description: "Use when reviewing, improving, or building Spring Boot 4.0.x applications -- including @SpringBootApplication, component annotations, bean management, @ConfigurationProperties, profiles, constructor injection, virtual threads, Jakarta EE namespace, and scheduled tasks."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: spring boot, spring, bean, autowired, configuration, profile, spring boot 4, jakarta
  role: specialist
  scope: spring-boot
  original-author: Juan Antonio Breña Moral
  related-skills: spring-boot-rest, spring-data-access, spring-boot-testing
---

# Spring Boot Core

Apply Spring Boot core guidelines for annotations, bean management, configuration, and dependency injection. Aligned with Spring Boot 4.0.x / Spring Framework 7.0.x.

## When to Use This Skill

- Review Spring Boot application structure and configuration
- Set up new Spring Boot projects
- Review bean definitions and dependency injection patterns
- Configure application properties and profiles
- Enable virtual threads for I/O-bound workloads

## Coverage

- `@SpringBootApplication` and main application class
- Component annotations: `@RestController`, `@Service`, `@Repository`
- Bean definition, scoping, lifecycle
- `@ConfigurationProperties` with `@Validated` for fail-fast startup
- Component scanning and package organization
- Conditional configuration and profiles (`@Profile`, `@ConditionalOn*`)
- Constructor dependency injection (only pattern recommended)
- `@Primary` and `@Qualifier` for disambiguation
- Graceful shutdown for in-flight work
- Virtual threads on supported stacks
- Jakarta EE namespace consistency (`jakarta.*` only)
- Scheduled tasks and background processing

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full Spring Boot core guidelines | `references/core-guidelines.md` | Before any Spring Boot review |
| Backend architecture checklist | `references/backend-architecture-checklist.md` | Architecture review or new project setup |

## Related Rules

- `rules/spring/core.mdc` -- Spring Boot core rules
