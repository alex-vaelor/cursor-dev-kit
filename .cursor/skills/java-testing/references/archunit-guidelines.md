# ArchUnit Guidelines

ArchUnit is a library for checking Java architecture rules as unit tests. It validates layer dependencies, naming conventions, cycle detection, and custom constraints at compile time.

## Dependency

```xml
<dependency>
  <groupId>com.tngtech.archunit</groupId>
  <artifactId>archunit-junit5</artifactId>
  <version>1.3.0</version>
  <scope>test</scope>
</dependency>
```

## Common Architecture Rules

### Layer Dependency Rules

```java
@AnalyzeClasses(packages = "com.example")
class LayerDependencyTest {

    @ArchTest
    static final ArchRule services_should_not_depend_on_controllers =
        noClasses().that().resideInAPackage("..service..")
            .should().dependOnClassesThat().resideInAPackage("..web..");

    @ArchTest
    static final ArchRule controllers_should_not_access_repositories =
        noClasses().that().resideInAPackage("..web..")
            .should().dependOnClassesThat().resideInAPackage("..repository..");
}
```

### Naming Convention Rules

```java
@ArchTest
static final ArchRule controllers_should_be_suffixed =
    classes().that().resideInAPackage("..web..")
        .and().areAnnotatedWith(RestController.class)
        .should().haveSimpleNameEndingWith("Controller");

@ArchTest
static final ArchRule services_should_be_suffixed =
    classes().that().resideInAPackage("..service..")
        .and().areAnnotatedWith(Service.class)
        .should().haveSimpleNameEndingWith("Service");
```

### No Cycle Rule

```java
@ArchTest
static final ArchRule no_package_cycles =
    slices().matching("com.example.(*)..")
        .should().beFreeOfCycles();
```

### DDD Rules

```java
@ArchTest
static final ArchRule domain_should_not_depend_on_infrastructure =
    noClasses().that().resideInAPackage("..domain..")
        .should().dependOnClassesThat().resideInAnyPackage("..infrastructure..", "..web..");

@ArchTest
static final ArchRule no_javax_imports =
    noClasses().should().dependOnClassesThat()
        .resideInAnyPackage("javax..");
```

### Spring-Specific Rules

```java
@ArchTest
static final ArchRule no_field_injection =
    noFields().should().beAnnotatedWith(Autowired.class)
        .because("Use constructor injection instead");

@ArchTest
static final ArchRule repositories_should_be_interfaces =
    classes().that().resideInAPackage("..repository..")
        .should().beInterfaces();
```

## Best Practices

- Place ArchUnit tests in a dedicated `architecture` test package
- Run with every build (`./mvnw clean verify`)
- Start with a few critical rules; add more incrementally
- Use `@ArchIgnore` sparingly for documented exceptions
- Combine with Checkstyle and SpotBugs for comprehensive quality gates

## When to Use ArchUnit

| Scenario | ArchUnit Rule |
|----------|--------------|
| Enforce layer separation | Layer dependency rules |
| Prevent circular dependencies | Cycle detection |
| Enforce naming conventions | Class name suffix rules |
| DDD boundary enforcement | Domain isolation rules |
| Migration validation | No-javax, no-legacy rules |
| Spring best practices | No field injection, interface repositories |
