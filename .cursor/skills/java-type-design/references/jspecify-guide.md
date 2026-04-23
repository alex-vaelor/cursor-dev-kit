# JSpecify Null Safety Guide

## What Is JSpecify

JSpecify provides standard null-safety annotations for Java. It replaces the fragmented landscape of `@Nullable`/`@NonNull` annotations from JSR-305, Checker Framework, JetBrains, Spring, and others.

## Core Annotations

| Annotation | Scope | Meaning |
|-----------|-------|---------|
| `@NullMarked` | Package, class, method | Everything in scope is non-null by default |
| `@Nullable` | Field, parameter, return, type use | This specific element can be null |
| `@NonNull` | Field, parameter, return, type use | Explicitly non-null (redundant inside `@NullMarked`) |

## Package-Level Setup

### package-info.java
```java
@NullMarked
package com.example.app.order;

import org.jspecify.annotations.NullMarked;
```

After this declaration, every reference type in the `com.example.app.order` package is assumed non-null unless annotated with `@Nullable`.

### Apply to Every Package
Create `package-info.java` in every package root. This is the single most impactful null-safety action.

## Usage Patterns

### Method Signatures
```java
@NullMarked
public class OrderService {
    // name and email are non-null (default from @NullMarked)
    // phone is nullable (explicitly marked)
    public User createUser(String name, String email, @Nullable String phone) {
        Objects.requireNonNull(name, "name must not be null");
        Objects.requireNonNull(email, "email must not be null");
        // phone may be null -- handle gracefully
    }

    // Return type is non-null (caller does not need to check)
    public Order findById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new OrderNotFoundException(id));
    }

    // Return type is nullable (caller must handle null)
    public @Nullable Order findByReference(String ref) {
        return repository.findByReference(ref).orElse(null);
    }
}
```

### Prefer Optional over @Nullable for Return Types
```java
// Preferred: explicit Optional return
public Optional<Order> findByReference(String ref) {
    return repository.findByReference(ref);
}

// Acceptable: @Nullable when Optional adds overhead (hot path)
public @Nullable CachedItem lookupCache(String key) {
    return cache.get(key);
}
```

### Collections
```java
// Non-null list of non-null items (default inside @NullMarked)
public List<Order> findAll() { return List.of(); }

// Non-null list where items can be null (rare, usually a smell)
public List<@Nullable String> parseOptionalFields() { }

// NEVER return null collections
// BAD:  return null;
// GOOD: return List.of();
```

### Generics
```java
// Type parameter bounds with nullness
public <T> T requireNonNull(T value) {
    return Objects.requireNonNull(value);
}

// Nullable type argument
public <T> @Nullable T findFirst(List<T> items, Predicate<T> predicate) {
    return items.stream().filter(predicate).findFirst().orElse(null);
}
```

## Maven Dependency

```xml
<dependency>
  <groupId>org.jspecify</groupId>
  <artifactId>jspecify</artifactId>
  <version>1.0.0</version>
</dependency>
```

## Integration with NullAway

NullAway is a compile-time checker that enforces JSpecify annotations as errors:

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <configuration>
    <compilerArgs>
      <arg>-XDcompilePolicy=simple</arg>
      <arg>-Xplugin:ErrorProne -XepOpt:NullAway:AnnotatedPackages=com.example</arg>
    </compilerArgs>
    <annotationProcessorPaths>
      <path>
        <groupId>com.google.errorprone</groupId>
        <artifactId>error_prone_core</artifactId>
        <version>2.28.0</version>
      </path>
      <path>
        <groupId>com.uber.nullaway</groupId>
        <artifactId>nullaway</artifactId>
        <version>0.11.1</version>
      </path>
    </annotationProcessorPaths>
  </configuration>
</plugin>
```

## IDE Support

| IDE | Support |
|-----|---------|
| IntelliJ IDEA | Recognizes JSpecify annotations for inspections and warnings |
| Eclipse | Partial support; configure null analysis to use JSpecify |
| VS Code (Java Extension) | Basic support via Error Prone |

## Migration from Other Annotations

| From | To JSpecify | Notes |
|------|------------|-------|
| `javax.annotation.Nonnull` (JSR-305) | Remove (default in `@NullMarked`) | JSR-305 was never finalized |
| `javax.annotation.Nullable` (JSR-305) | `@Nullable` (JSpecify) | Same semantics |
| `@org.jetbrains.annotations.NotNull` | Remove (default in `@NullMarked`) | JetBrains-specific |
| `@org.springframework.lang.NonNull` | Remove (default in `@NullMarked`) | Spring is adopting JSpecify |
| `@org.springframework.lang.Nullable` | `@Nullable` (JSpecify) | Spring is migrating |

## Spring Framework JSpecify Adoption

Spring Framework 7.0 is migrating to JSpecify annotations. This means:
- Spring's own APIs are null-safe by default
- IDE warnings align with Spring's contracts
- Custom code using `@NullMarked` integrates seamlessly

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| No `@NullMarked` on packages | Annotations are per-field only; no default safety | Add `package-info.java` with `@NullMarked` everywhere |
| `@Nullable` on everything | Defeats the purpose of null safety | Use `@NullMarked` as default; `@Nullable` only where needed |
| Returning null collections | Forces callers to null-check | Return `List.of()`, `Set.of()`, `Map.of()` |
| Mixing annotation libraries | Conflicting semantics, tooling confusion | Standardize on JSpecify; remove JSR-305/Spring annotations |
| Ignoring NullAway warnings | Null dereferences at runtime | Treat NullAway as compile error in CI |
