# Java Cross-Cutting Conventions

## Language Baseline

- **Minimum**: Java 17 LTS
- **Recommended**: Java 21 LTS
- **Target Spring**: Spring Framework 7.0.x / Spring Boot 4.0.x
- **Jakarta EE**: 11 (Servlet 6.1, JPA 3.2, Bean Validation 3.1)

## Naming Conventions

### Packages
- Reverse domain notation: `com.company.project.module`
- All lowercase, no underscores: `com.example.ordermanagement`
- Group by feature/domain, not by technical layer
- Avoid single-word generic names: prefer `com.example.billing.invoice` over `com.example.utils`

### Classes and Interfaces
- PascalCase: `OrderService`, `PaymentGateway`
- Interfaces: noun or adjective (`Serializable`, `PaymentProcessor`) -- no `I` prefix
- Implementations: descriptive name, not `Impl` suffix when avoidable (`StripePaymentProcessor`, not `PaymentProcessorImpl`)
- Records: noun describing the data (`OrderSummary`, `Coordinate`)
- Sealed hierarchies: base class describes the concept (`Shape`), permits list the variants (`Circle`, `Rectangle`)

### Methods and Variables
- camelCase: `calculateTotal`, `isActive`
- Boolean methods: `is*`, `has*`, `can*`, `should*` prefix
- Factory methods: `of`, `from`, `create`, `valueOf`
- Conversion methods: `toList`, `asStream`, `toString`

### Constants
- UPPER_SNAKE_CASE: `MAX_RETRIES`, `DEFAULT_TIMEOUT_MS`
- Defined in the class that owns them, not in a shared `Constants` class

### Test Classes
- Mirror source class name with `Test` suffix: `OrderService` -> `OrderServiceTest`
- Integration tests: `*IntegrationTest` or `*IT`
- Acceptance tests: `*AcceptanceTest` or `*AT`
- Test methods: descriptive names using `should*` or given-when-then style

## Modern Java Patterns

### Records (Java 16+)
- Use for immutable data carriers: DTOs, value objects, API responses
- Prefer compact constructors for validation
- Do not add mutable fields or setters

### Sealed Classes (Java 17+)
- Use to model closed type hierarchies with exhaustive switch
- All permitted subclasses in the same package (or same file for small hierarchies)
- Subclasses must be `final`, `sealed`, or `non-sealed`

### Pattern Matching
- `instanceof` pattern matching (Java 16+): `if (obj instanceof String s)`
- Pattern matching for switch (Java 21): prefer over if-else chains for type dispatch
- Record patterns (Java 21): `case Point(int x, int y)` for destructuring

### Modern Switch
- Use switch expressions with `->` (arrow) syntax for all new code
- Return values from switch expressions when applicable
- Exhaustive switch over sealed types and enums

### Other Modern Features
- Text blocks for multi-line strings
- `var` for local variables when the type is obvious from the right-hand side
- Sequenced collections (`SequencedCollection`, `SequencedMap`) for ordered access (Java 21)
- Unnamed variables `_` for intentionally unused bindings (Java 22 preview, Java 21 compatible with `--enable-preview`)

## Code Organization

### File Structure
- One public class per file
- File name matches the public class name
- Related records, sealed class variants may share a file when small

### Import Ordering
1. `java.*` standard library
2. `jakarta.*` Jakarta EE
3. Third-party libraries (alphabetical by group)
4. Project-internal imports
5. Static imports last

No wildcard imports. Configure IDE/formatter to enforce.

### Class Member Ordering
1. Static fields (constants first)
2. Instance fields
3. Constructors
4. Public methods
5. Package-private methods
6. Private methods
7. Inner classes / records / enums

## Error Handling

- Catch specific exceptions, never bare `catch (Exception e)` at business logic level
- Use custom domain exceptions extending `RuntimeException` for business errors
- Use `try-with-resources` for all `AutoCloseable` resources
- Log at the boundary, not at every catch site (avoid log-and-throw)
- Include context in exception messages: what failed, what input caused it

## Logging

- SLF4J API as the facade
- Parameterized messages: `log.info("Order {} processed in {}ms", orderId, elapsed)`
- Never concatenate strings in log calls
- Levels: ERROR (system failure), WARN (recoverable issue), INFO (business events), DEBUG (developer diagnostics)
- Include correlation/request IDs in structured logging

## Dependency Injection

- Constructor injection only (no field injection, no setter injection)
- Mark dependencies `final`
- Single constructor per class (Spring auto-detects it)
- Use `@Qualifier` or `@Primary` when multiple beans of the same type exist

## Null Safety

- Use JSpecify annotations (`@NullMarked`, `@Nullable`) at the package level
- Return `Optional` for methods that may not produce a result
- Never return `null` from collections -- return empty collections
- Validate parameters with `Objects.requireNonNull` at public API boundaries

## Lombok

Version: **1.18.44+** (required for Spring Boot 4.0.x compatibility).

### When to Use Lombok vs Records

| Use Case | Use | Why |
|----------|-----|-----|
| DTOs, value objects, API payloads | Records | Language-level; no annotation processor |
| JPA/Hibernate entities | Lombok (`@Getter`/`@Setter`) | Entities need no-arg constructor, mutable fields, proxy compatibility |
| Spring service/component classes | `@RequiredArgsConstructor` | Generates constructor for `final` fields; clean DI |
| Logging | `@Slf4j` | Eliminates boilerplate `Logger` field |
| Complex object construction | `@Builder` | No language equivalent for multi-optional-parameter builders |

### Preferred Annotations

- `@RequiredArgsConstructor` -- Spring beans with `final` fields
- `@Slf4j` -- logger initialization
- `@Builder` -- complex object construction
- `@Getter` / `@Setter` -- JPA entities only
- `@With` -- immutable copy methods
- `@UtilityClass` -- static utility classes

### Anti-Patterns

- **Never `@Data` on JPA entities** -- breaks lazy loading via `equals`/`hashCode`
- **Never `@Value` for new code** -- prefer records
- **Never `@SneakyThrows`** -- hides checked exceptions
- **Never `@AllArgsConstructor` on Spring beans** -- use `@RequiredArgsConstructor` with `final` fields

### Project Configuration

Every project using Lombok must include `lombok.config` at project root:
```
config.stopBubbling = true
lombok.addLombokGeneratedAnnotation = true
lombok.extern.findbugs.addSuppressFBWarnings = true
```

## Jackson / Serialization

### Conventions
- Use Spring Boot auto-configured `ObjectMapper`; customize via `application.yml` or `Jackson2ObjectMapperBuilderCustomizer`
- **NEVER** create a separate `ObjectMapper` bean unless there is a specific need (overrides Spring Boot defaults)
- Dates and times: ISO-8601 strings (`write-dates-as-timestamps: false`)
- Null handling: `default-property-inclusion: non_null` as project default
- Unknown properties: `fail-on-unknown-properties: true` to catch contract drift
- Register `JavaTimeModule` and `ParameterNamesModule` (Spring Boot includes them by default)

### Record Deserialization
Records work out of the box with Spring Boot's Jackson configuration. Use `@JsonProperty` for custom field names:
```java
public record OrderResponse(
    Long id,
    @JsonProperty("order_status") OrderStatus status,
    @JsonFormat(pattern = "yyyy-MM-dd") LocalDate deliveryDate
) {}
```

### Security
- **NEVER** enable default typing (`ObjectMapper.enableDefaultTyping()`)
- **NEVER** expose JPA entities directly in JSON responses; use record DTOs
- Use `@JsonIgnore` only as a secondary measure; prefer separate DTOs over annotation-based field hiding

## MapStruct

### Conventions
- Use `@Mapper(componentModel = "spring")` for Spring DI integration
- Set `unmappedTargetPolicy = ReportingPolicy.ERROR` to catch mapping gaps at compile time
- Keep mapping logic in mapper interfaces, not in controllers or services
- For Lombok entities: configure `lombok-mapstruct-binding` and ensure annotation processor order is Lombok before MapStruct

### Maven Annotation Processor Order
```xml
<annotationProcessorPaths>
  <path>lombok</path>
  <path>lombok-mapstruct-binding</path>
  <path>mapstruct-processor</path>
</annotationProcessorPaths>
```
