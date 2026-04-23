# Java Style Guide

This style guide is based on the Google Java Style Guide with project-specific overrides aligned with modern Java (17/21) and Spring Boot 4.

## Source File Structure

1. License/copyright header (if required)
2. Package statement
3. Import statements (no wildcards)
4. Exactly one top-level class

## Import Ordering

1. `java.*`
2. `jakarta.*`
3. Third-party imports (alphabetical by top-level package)
4. Project-internal imports
5. Static imports (last)

Blank line between each group. No wildcard imports.

## Formatting

| Rule | Value |
|------|-------|
| Indentation | 4 spaces (no tabs) |
| Line length | 120 characters maximum |
| Braces | K&R style (opening brace on same line) |
| Blank lines | One blank line between methods; two before class declarations |
| Trailing whitespace | None |
| File encoding | UTF-8 |
| Line endings | LF (Unix-style) |
| Final newline | Required |

## Naming Conventions

| Element | Convention | Examples |
|---------|-----------|----------|
| Packages | lowercase, dot-separated | `com.example.billing.invoice` |
| Classes | PascalCase, nouns | `OrderService`, `InvoiceRepository` |
| Interfaces | PascalCase, nouns or adjectives | `Serializable`, `PaymentGateway` |
| Methods | camelCase, verbs | `calculateTotal`, `findByEmail` |
| Variables | camelCase | `orderCount`, `isActive` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES`, `DEFAULT_TIMEOUT_MS` |
| Type parameters | Single uppercase letter or short name | `T`, `E`, `K`, `V` |
| Test methods | camelCase with `should` prefix | `shouldReturnEmptyWhenNotFound` |

## Records

```java
public record OrderSummary(
    String orderId,
    BigDecimal total,
    Instant createdAt
) {
    public OrderSummary {
        Objects.requireNonNull(orderId, "orderId must not be null");
        if (total.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("total must not be negative");
        }
    }
}
```

## Sealed Classes

```java
public sealed interface Shape permits Circle, Rectangle, Triangle {
    double area();
}

public record Circle(double radius) implements Shape {
    public double area() { return Math.PI * radius * radius; }
}
```

## Switch Expressions

```java
String label = switch (status) {
    case PENDING -> "Waiting";
    case ACTIVE -> "In Progress";
    case COMPLETED -> "Done";
};
```

## Pattern Matching

```java
if (obj instanceof String s && !s.isEmpty()) {
    process(s);
}

return switch (shape) {
    case Circle c -> "Circle with radius " + c.radius();
    case Rectangle r -> "Rectangle " + r.width() + "x" + r.height();
    case Triangle t -> "Triangle";
};
```

## Optional Usage

```java
// Return type
public Optional<User> findByEmail(String email) { ... }

// Chaining
repository.findByEmail(email)
    .map(User::name)
    .orElse("Unknown");

// Never as field or parameter
// Never: private Optional<String> name;
// Never: public void setName(Optional<String> name)
```

## Annotations

- `@Override` on every overriding method
- `@Deprecated(since = "x.y", forRemoval = true)` with migration note in Javadoc
- `@SuppressWarnings("unchecked")` scoped as narrowly as possible with justification comment
- JSpecify: `@NullMarked` at package level in `package-info.java`

## Checkstyle Configuration

Use a project-specific `checkstyle.xml` based on Google checks with these overrides:
- `LineLength`: 120
- `Indentation`: basicOffset=4, caseIndent=4
- `ImportOrder`: groups matching the import ordering above
- `AvoidStarImport`: enabled
