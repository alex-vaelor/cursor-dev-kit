# Maven Quality Plugin Setup

Maven plugins are the CI-enforced quality gates. Git hooks call them locally for fast feedback.

## Spotless (Code Formatting)

Auto-formats Java code and other files. The single source of truth for formatting.

### pom.xml Configuration

```xml
<plugin>
    <groupId>com.diffplug.spotless</groupId>
    <artifactId>spotless-maven-plugin</artifactId>
    <version>2.44.0</version>
    <configuration>
        <java>
            <palantirJavaFormat>
                <version>2.50.0</version>
            </palantirJavaFormat>
            <removeUnusedImports/>
            <trimTrailingWhitespace/>
            <endWithNewline/>
        </java>
        <pom>
            <sortPom>
                <expandEmptyElements>false</expandEmptyElements>
            </sortPom>
        </pom>
    </configuration>
</plugin>
```

### Commands

```bash
./mvnw spotless:check     # Fail if code is not formatted (CI + pre-commit hook)
./mvnw spotless:apply     # Auto-fix formatting (developer convenience)
```

### Integration with pre-commit hook

```bash
#!/bin/sh
# .githooks/pre-commit
./mvnw spotless:check -q || {
    echo "Formatting issues found. Run: ./mvnw spotless:apply"
    exit 1
}
```

## Checkstyle (Style Rules)

Enforces coding standards beyond formatting: naming, Javadoc, import ordering, complexity limits.

### pom.xml Configuration

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-checkstyle-plugin</artifactId>
    <version>3.5.0</version>
    <dependencies>
        <dependency>
            <groupId>com.puppycrawl.tools</groupId>
            <artifactId>checkstyle</artifactId>
            <version>10.20.2</version>
        </dependency>
    </dependencies>
    <configuration>
        <configLocation>checkstyle.xml</configLocation>
        <consoleOutput>true</consoleOutput>
        <failOnViolation>true</failOnViolation>
        <violationSeverity>warning</violationSeverity>
    </configuration>
    <executions>
        <execution>
            <id>checkstyle-check</id>
            <phase>validate</phase>
            <goals><goal>check</goal></goals>
        </execution>
    </executions>
</plugin>
```

### Minimal checkstyle.xml

```xml
<?xml version="1.0"?>
<!DOCTYPE module PUBLIC
    "-//Checkstyle//DTD Checkstyle Configuration 1.3//EN"
    "https://checkstyle.org/dtds/configuration_1_3.dtd">
<module name="Checker">
    <module name="TreeWalker">
        <module name="ConstantName"/>
        <module name="LocalVariableName"/>
        <module name="MemberName"/>
        <module name="MethodName"/>
        <module name="PackageName"/>
        <module name="ParameterName"/>
        <module name="TypeName"/>
        <module name="AvoidStarImport"/>
        <module name="UnusedImports"/>
        <module name="NeedBraces"/>
        <module name="LeftCurly"/>
        <module name="RightCurly"/>
        <module name="CyclomaticComplexity">
            <property name="max" value="10"/>
        </module>
        <module name="MethodLength">
            <property name="max" value="30"/>
        </module>
    </module>
    <module name="FileLength">
        <property name="max" value="500"/>
    </module>
    <module name="NewlineAtEndOfFile"/>
</module>
```

## SpotBugs (Bug Detection)

Static analysis that finds potential bugs: null pointer dereferences, resource leaks, concurrency issues.

### pom.xml Configuration

```xml
<plugin>
    <groupId>com.github.spotbugs</groupId>
    <artifactId>spotbugs-maven-plugin</artifactId>
    <version>4.8.6.6</version>
    <executions>
        <execution>
            <phase>verify</phase>
            <goals><goal>check</goal></goals>
        </execution>
    </executions>
</plugin>
```

### Commands

```bash
./mvnw spotbugs:check     # Run in CI
./mvnw spotbugs:gui       # Open GUI to explore findings
```

## ArchUnit (Architecture Rules)

Not a Maven plugin but an architecture testing library. Enforces package dependencies and layer boundaries.

### Dependency

```xml
<dependency>
    <groupId>com.tngtech.archunit</groupId>
    <artifactId>archunit-junit5</artifactId>
    <version>1.3.0</version>
    <scope>test</scope>
</dependency>
```

### Example Test

```java
@AnalyzeClasses(packages = "com.example")
class ArchitectureTest {

    @ArchTest
    static final ArchRule services_should_not_access_controllers =
        noClasses().that().resideInAPackage("..service..")
            .should().accessClassesThat().resideInAPackage("..controller..");

    @ArchTest
    static final ArchRule repositories_should_only_be_accessed_by_services =
        noClasses().that().resideOutsideOfPackage("..service..")
            .should().accessClassesThat().resideInAPackage("..repository..");
}
```

## Recommended Maven Profile for Quick Checks

```xml
<profile>
    <id>quick-check</id>
    <build>
        <plugins>
            <plugin>
                <groupId>com.diffplug.spotless</groupId>
                <artifactId>spotless-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <phase>validate</phase>
                        <goals><goal>check</goal></goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</profile>
```

Use in hooks: `./mvnw validate -P quick-check -q`

## Summary

| Tool | What It Checks | Phase | Hook |
|------|---------------|-------|------|
| Spotless | Code formatting | validate | pre-commit |
| Checkstyle | Style rules, complexity | validate | pre-commit |
| SpotBugs | Potential bugs | verify | pre-push |
| ArchUnit | Architecture rules | test | pre-push |
