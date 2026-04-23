# Spring Boot Migration Guide

## Spring Boot 2.x to 3.x

### Java Baseline
- Minimum: Java 17 (was Java 8)
- Target: Java 17 or 21

### Namespace Migration
- All `javax.*` -> `jakarta.*` (Jakarta EE 9+)
- Affects: `javax.servlet`, `javax.persistence`, `javax.validation`, `javax.annotation`
- Use OpenRewrite or IDE refactoring for automated migration

### Spring Security
- `WebSecurityConfigurerAdapter` removed
- Use `SecurityFilterChain` `@Bean` instead
- Method security: `@EnableMethodSecurity` replaces `@EnableGlobalMethodSecurity`

### Observability
- Micrometer Observation API replaces custom metrics
- Spring Boot Actuator metrics auto-configuration updated

### Configuration Properties
- Some properties renamed or removed
- Run Spring Boot Migrator (`spring-boot-migrator`) to detect

## Spring Boot 3.x to 4.x

### Spring Framework 7
- Jakarta EE 11 (Servlet 6.1, JPA 3.2, Bean Validation 3.1)
- JSpecify-based null safety
- Jackson 3.0 as primary (2.x deprecated fallback)
- JUnit 6 baseline

### Removed APIs
- `javax.annotation` and `javax.inject` package support fully removed
- `ListenableFuture` removed -- use `CompletableFuture`
- Undertow support removed -- use Tomcat or Netty
- Path suffix matching and trailing slash matching removed
- Spring JCL module removed

### Testing
- `@MockBean` -> `@MockitoBean`
- `@SpyBean` -> `@MockitoSpyBean`
- JUnit 6 supported alongside JUnit 5

### OpenAPI Generator
- Use `useSpringBoot4` flag for code generation
- Update generated model types for Jackson 3.0 annotations

### Configuration
- Review `application.properties` / `application.yml` for renamed keys
- Check `spring-boot-properties-migrator` for automated detection

## Migration Steps

1. **Prepare**: Ensure all tests pass on current version
2. **Update parent POM**: Change Spring Boot parent version
3. **Namespace**: Replace `javax.*` with `jakarta.*` (if not done in 3.x)
4. **Fix compilation**: Address removed/changed APIs
5. **Update tests**: Migrate `@MockBean` to `@MockitoBean`
6. **Run full suite**: Fix failures
7. **Review configuration**: Check for renamed properties
8. **Update dependencies**: Align transitive dependencies with new baseline
9. **Adopt new features**: Virtual threads, JSpecify null safety

## Tools

- **Spring Boot Migrator**: Automated migration assistance
- **OpenRewrite**: Automated code migration recipes for Spring (see recipes below)
- **IDE refactoring**: IntelliJ IDEA has built-in Jakarta migration support
- **jdeprscan**: JDK tool to scan for usage of deprecated APIs

## OpenRewrite Recipes

OpenRewrite provides automated recipes for Java and Spring migrations. Add to `pom.xml`:

```xml
<plugin>
  <groupId>org.openrewrite.maven</groupId>
  <artifactId>rewrite-maven-plugin</artifactId>
  <version>5.x</version>
  <configuration>
    <activeRecipes>
      <recipe>org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_4</recipe>
    </activeRecipes>
  </configuration>
  <dependencies>
    <dependency>
      <groupId>org.openrewrite.recipe</groupId>
      <artifactId>rewrite-spring</artifactId>
      <version>5.x</version>
    </dependency>
  </dependencies>
</plugin>
```

### Key Recipes

| Recipe | Purpose |
|--------|---------|
| `UpgradeSpringBoot_3_4` | Migrate Spring Boot 2.x/3.x to 3.4 |
| `org.openrewrite.java.migrate.UpgradeToJava21` | Migrate to Java 21 APIs |
| `org.openrewrite.java.migrate.jakarta.JavaxMigrationToJakarta` | `javax.*` to `jakarta.*` namespace |
| `org.openrewrite.java.testing.junit5.JUnit4to5Migration` | JUnit 4 to JUnit 5 |
| `org.openrewrite.java.spring.security6.UpgradeSpringSecurity_6_4` | Spring Security migration |

Run: `./mvnw rewrite:run` to apply, `./mvnw rewrite:dryRun` to preview changes.

## ArchUnit for Migration Validation

Use ArchUnit tests to enforce migration completeness:

```java
@AnalyzeClasses(packages = "com.example")
class MigrationArchTest {
    @ArchTest
    static final ArchRule no_javax_imports = noClasses()
        .should().dependOnClassesThat()
        .resideInAnyPackage("javax..");
}
```
