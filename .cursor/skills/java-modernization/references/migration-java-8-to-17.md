# Migration: Java 8 to Java 17

## Overview

Java 17 LTS is the minimum recommended baseline. This guide covers the key changes and actions required when migrating from Java 8 (or 11) to Java 17.

## Critical Breaking Changes

### Module System (Java 9+)
- Strong encapsulation of JDK internals
- `--add-opens` / `--add-exports` flags may be needed for libraries that access JDK internals via reflection
- Common offenders: Lombok, some serialization libraries, test frameworks
- Action: Update dependencies to module-aware versions first

### Removed APIs
- `javax.xml.bind` (JAXB): Use `jakarta.xml.bind:jakarta.xml.bind-api` + implementation
- `javax.activation`: Use `jakarta.activation:jakarta.activation-api`
- `javax.annotation`: Use `jakarta.annotation:jakarta.annotation-api`
- `java.corba`, `java.transaction`, `java.xml.ws`: Remove or replace with Jakarta equivalents
- `java.security.acl`: Removed, use `java.security.Permission`
- `Nashorn JavaScript engine`: Use GraalJS or other alternatives

### Changed Defaults
- `java.version` system property format changed (e.g., "17" not "17.0.1")
- `System.getSecurityManager()` always returns null (Security Manager deprecated for removal)
- Applet API deprecated for removal

## Language Features to Adopt

### From Java 9
- `List.of()`, `Set.of()`, `Map.of()` for immutable collections
- Try-with-resources with effectively final variables
- Private interface methods
- `Optional.ifPresentOrElse()`, `Optional.or()`, `Optional.stream()`

### From Java 10
- Local variable type inference: `var list = new ArrayList<String>()`
- `Optional.orElseThrow()` (no-arg)
- Unmodifiable copies: `List.copyOf()`, `Set.copyOf()`, `Map.copyOf()`

### From Java 11
- `String` methods: `isBlank()`, `strip()`, `lines()`, `repeat()`
- `Files.readString()`, `Files.writeString()`
- `HttpClient` (replacement for `HttpURLConnection`)
- `var` in lambda parameters

### From Java 14
- Switch expressions (final): `var result = switch (x) { case 1 -> "one"; ... };`
- `NullPointerException` messages include variable name
- Records (preview, final in 16)

### From Java 15
- Text blocks (final): `""" ... """`
- Sealed classes (preview, final in 17)

### From Java 16
- Records (final)
- Pattern matching for instanceof (final): `if (obj instanceof String s)`
- `Stream.toList()` for unmodifiable list

### From Java 17
- Sealed classes (final)
- Pattern matching for switch (preview)
- Enhanced pseudo-random number generators

## Migration Steps

1. **Update build tools**: Maven 3.9+, Gradle 8+
2. **Update dependencies**: Check all dependencies for Java 17 compatibility
3. **Fix compilation**: Address removed APIs and module access issues
4. **Update CI**: Change JDK version in CI pipelines
5. **Add `--add-opens` flags** temporarily for reflection-dependent libraries
6. **Run full test suite**: Fix any runtime issues
7. **Adopt new features**: Records, sealed classes, pattern matching, text blocks
8. **Remove workarounds**: Replace `--add-opens` with proper library updates

## Common Pitfalls

- Forgetting to update Maven/Gradle compiler plugin target version
- Libraries with hard dependencies on removed `javax.*` packages
- Reflection-based frameworks accessing sealed JDK internals
- `SecurityManager` usage (deprecated for removal)
