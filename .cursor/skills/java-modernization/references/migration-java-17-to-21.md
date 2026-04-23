# Migration: Java 17 to Java 21

## Overview

Java 21 LTS is the recommended baseline. Migrating from Java 17 is generally smooth since there are no major breaking changes -- mostly new features to adopt.

## New Language Features (Final in Java 21)

### Virtual Threads (JEP 444)
- Lightweight threads managed by the JVM
- `Executors.newVirtualThreadPerTaskExecutor()` for I/O-bound workloads
- Do not pool virtual threads
- Watch for pinning: avoid `synchronized` around blocking I/O; use `ReentrantLock` instead
- Enable in Spring Boot: `spring.threads.virtual.enabled=true`

### Record Patterns (JEP 440)
- Destructure records in `instanceof` and `switch`:
  ```java
  if (obj instanceof Point(int x, int y)) { ... }
  ```

### Pattern Matching for switch (JEP 441)
- Full pattern matching in switch expressions/statements
- Guard clauses: `case String s when s.length() > 10 ->`
- Null handling: `case null ->`
- Exhaustive switch over sealed types (no default needed)

### Sequenced Collections (JEP 431)
- `SequencedCollection`: `getFirst()`, `getLast()`, `reversed()`
- `SequencedSet`: `SequencedCollection` + `Set`
- `SequencedMap`: `firstEntry()`, `lastEntry()`, `sequencedKeySet()`
- Implemented by `ArrayList`, `LinkedHashSet`, `LinkedHashMap`, `TreeSet`, `TreeMap`

## Preview Features (Consider for Experimentation)

### Unnamed Patterns and Variables (JEP 443, preview)
- `_` for intentionally unused variables: `catch (Exception _)`
- Unnamed record patterns: `case Point(var x, _) ->`

### String Templates (JEP 430, preview)
- `STR."Hello \{name}"` -- templated string processing
- Note: may evolve in future releases

## Migration Steps

1. **Update JDK**: Install JDK 21 (Temurin, Corretto, or Oracle)
2. **Update build config**: Set compiler source/target to 21
3. **Update CI**: Change JDK version in CI pipelines
4. **Run test suite**: Verify no regressions
5. **Adopt features incrementally**:
   - Start with sequenced collections (drop-in replacements)
   - Apply pattern matching for switch where if-else chains exist
   - Evaluate virtual threads for I/O-bound services
   - Refactor DTOs to use record patterns

## Compatibility Notes

- No removed APIs between 17 and 21 (smooth upgrade)
- `--enable-preview` required for unnamed patterns/variables and string templates
- Virtual threads may interact with existing ThreadLocal usage -- audit and consider ScopedValue
- Some libraries may not be virtual-thread-safe (those using `synchronized` internally for I/O)
