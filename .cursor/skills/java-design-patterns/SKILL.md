---
name: java-design-patterns
description: "Use when applying or reviewing design patterns in Java -- including GOF creational, structural, and behavioral patterns adapted for modern Java with records, sealed classes, lambdas, and Spring integration."
risk: safe
source: extended
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: design pattern, factory, builder, strategy, observer, decorator, singleton, adapter, proxy, template method
  role: specialist
  scope: java-design
  related-skills: java-oop-design, java-modern-features, spring-boot-core
---

# Java Design Patterns

Apply classic and modern design patterns in Java using current language features (records, sealed classes, lambdas, functional interfaces) and Spring framework integration.

## When to Use This Skill

- Choose appropriate design patterns for a given problem
- Implement patterns using modern Java idioms
- Review code for pattern misuse or opportunities
- Refactor from anti-patterns to proper patterns
- Integrate patterns with Spring dependency injection

## Coverage

Refer to the design patterns guide for detailed examples and guidance on each pattern.

### Creational Patterns
- **Factory Method / Abstract Factory**: Use sealed interfaces + records for type-safe factories
- **Builder**: Use records with compact constructors for simple cases; Builder class for complex objects
- **Singleton**: `enum` singleton or Spring `@Bean` (singleton scope by default)
- **Prototype**: `record.withX()` copy methods or Cloneable

### Structural Patterns
- **Adapter**: Implement target interface, delegate to adaptee
- **Decorator**: Composition-based enhancement (works well with Spring `@Qualifier`)
- **Facade**: Simplify complex subsystem access
- **Proxy**: Spring AOP, `@Transactional`, `@Cacheable` are proxy-based

### Behavioral Patterns
- **Strategy**: Functional interfaces + lambdas for lightweight strategies; interface + implementations for complex ones
- **Observer**: Spring `ApplicationEventPublisher` / `@EventListener`
- **Template Method**: Abstract class with hook methods; or functional composition with `Consumer`/`Function`
- **Command**: Functional interfaces or sealed record hierarchies
- **Chain of Responsibility**: Spring Security filter chain, Servlet filter chain
- **State**: Sealed interfaces + records for state machines

## Constraints

- **MANDATORY**: Run `./mvnw compile` before and after pattern refactoring
- **VERIFY**: Run `./mvnw clean verify` after changes
- Prefer simplicity: do not apply patterns that add complexity without clear benefit

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Design patterns guide | `references/design-patterns-guide.md` | When selecting or implementing patterns |

## Related Rules

- `rules/java/coding-standards.mdc` -- naming and class design
- `rules/java/type-design.mdc` -- value objects and type hierarchies
- `rules/java/modern-features.mdc` -- records and sealed classes in patterns
- `rules/spring/core.mdc` -- Spring bean patterns (Singleton, Decorator, Observer)
