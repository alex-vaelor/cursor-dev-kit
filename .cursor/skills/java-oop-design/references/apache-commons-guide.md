# Apache Commons Guide for Java 17/21

## Overview

Apache Commons provides reusable Java components. With Java 17/21, many utilities that once required Commons now have standard library equivalents. Use Commons when it genuinely adds value over the JDK.

## Recommended Modules

### commons-lang3

```xml
<dependency>
  <groupId>org.apache.commons</groupId>
  <artifactId>commons-lang3</artifactId>
  <version>3.17.0</version>
</dependency>
```

| Class | Useful Methods | Java 17/21 Alternative |
|-------|---------------|----------------------|
| `StringUtils` | `isBlank()`, `isNotBlank()` | `String.isBlank()` (Java 11+) |
| `StringUtils` | `defaultIfBlank()`, `abbreviate()` | No direct equivalent |
| `StringUtils` | `join()` | `String.join()` or `Collectors.joining()` |
| `StringUtils` | `substringBetween()` | No direct equivalent |
| `ObjectUtils` | `defaultIfNull()` | `Objects.requireNonNullElse()` (Java 9+) |
| `ObjectUtils` | `firstNonNull()` | No direct equivalent |
| `RandomStringUtils` | `randomAlphanumeric()` | `RandomGenerator` (Java 17+) |
| `BooleanUtils` | `toBoolean(String)` | `Boolean.parseBoolean()` |
| `NumberUtils` | `isParsable()`, `toInt()` | Try-catch with `Integer.parseInt()` |

**Still valuable**: `StringUtils.defaultIfBlank()`, `StringUtils.abbreviate()`, `StringUtils.substringBetween()`, `ObjectUtils.firstNonNull()`.

### commons-collections4

```xml
<dependency>
  <groupId>org.apache.commons</groupId>
  <artifactId>commons-collections4</artifactId>
  <version>4.4</version>
</dependency>
```

| Class | Purpose | Java 17/21 Alternative |
|-------|---------|----------------------|
| `CollectionUtils.isEmpty()` | Null-safe empty check | Collection may be null? Use `Optional` |
| `MapUtils.getInteger()` | Typed map access | `Map.getOrDefault()` + cast |
| `ListUtils.partition()` | Chunk a list | No direct equivalent (useful) |
| `SetUtils.difference()` | Set operations | No direct equivalent |
| `MultiValuedMap` | Key → multiple values | `Map.computeIfAbsent(k, ArrayList::new)` |

**Still valuable**: `ListUtils.partition()`, `SetUtils.difference()`, `SetUtils.intersection()`.

### commons-io

```xml
<dependency>
  <groupId>commons-io</groupId>
  <artifactId>commons-io</artifactId>
  <version>2.17.0</version>
</dependency>
```

| Class | Purpose | Java 17/21 Alternative |
|-------|---------|----------------------|
| `FileUtils.readFileToString()` | Read file to string | `Files.readString()` (Java 11+) |
| `FileUtils.writeStringToFile()` | Write string to file | `Files.writeString()` (Java 11+) |
| `IOUtils.toString(InputStream)` | Stream to string | `new String(is.readAllBytes())` (Java 9+) |
| `IOUtils.copy()` | Copy streams | `InputStream.transferTo()` (Java 9+) |
| `FilenameUtils` | Path manipulation | `Path` API |

**Largely replaced by Java 17**: Most `FileUtils` and `IOUtils` methods have JDK equivalents.

### commons-codec

```xml
<dependency>
  <groupId>commons-codec</groupId>
  <artifactId>commons-codec</artifactId>
  <version>1.17.1</version>
</dependency>
```

| Class | Purpose | Java 17/21 Alternative |
|-------|---------|----------------------|
| `Base64` | Base64 encoding | `java.util.Base64` (Java 8+) |
| `DigestUtils.sha256Hex()` | Hash computation | `MessageDigest` + `HexFormat` (Java 17+) |
| `Hex.encodeHexString()` | Hex encoding | `HexFormat.of().formatHex()` (Java 17) |

**Largely replaced**: `HexFormat` (Java 17) and `java.util.Base64` cover most cases.

### commons-text

```xml
<dependency>
  <groupId>org.apache.commons</groupId>
  <artifactId>commons-text</artifactId>
  <version>1.12.0</version>
</dependency>
```

| Class | Purpose | Notes |
|-------|---------|-------|
| `StringSubstitutor` | Template string interpolation | Useful for dynamic templates |
| `StringEscapeUtils` | HTML/XML/JSON escaping | Use framework-level escaping instead |
| `WordUtils` | Capitalize, wrap text | Occasionally useful |

**Security note**: `StringSubstitutor` had a critical CVE (CVE-2022-42889 "Text4Shell") in older versions. Always use 1.10.0+.

## Decision: Commons vs JDK

```
Need the functionality?
├── JDK has an equivalent (Java 11+)?
│   ├── Yes → Use JDK
│   └── No → Is it in a single Commons method?
│       ├── Yes → Write it yourself (avoid whole dependency for one method)
│       └── No → Add Commons dependency
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| `StringUtils.isEmpty()` | `String.isEmpty()` exists since Java 6; `String.isBlank()` since Java 11 | Use JDK methods |
| `IOUtils.toString(is, "UTF-8")` | `new String(is.readAllBytes(), UTF_8)` since Java 9 | Use JDK |
| `FileUtils.readFileToString()` | `Files.readString()` since Java 11 | Use JDK |
| Adding `commons-io` for one method | Unnecessary dependency | Copy or inline the logic |
| `commons-codec` for Base64 | `java.util.Base64` since Java 8 | Use JDK |
