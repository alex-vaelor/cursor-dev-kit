# JaCoCo Coverage Best Practices

## Maven Plugin Configuration

```xml
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <version>0.8.12</version>
  <executions>
    <execution>
      <id>prepare-agent</id>
      <goals><goal>prepare-agent</goal></goals>
    </execution>
    <execution>
      <id>report</id>
      <phase>verify</phase>
      <goals><goal>report</goal></goals>
    </execution>
    <execution>
      <id>check</id>
      <phase>verify</phase>
      <goals><goal>check</goal></goals>
      <configuration>
        <rules>
          <rule>
            <element>BUNDLE</element>
            <limits>
              <limit>
                <counter>LINE</counter>
                <value>COVEREDRATIO</value>
                <minimum>0.80</minimum>
              </limit>
              <limit>
                <counter>BRANCH</counter>
                <value>COVEREDRATIO</value>
                <minimum>0.70</minimum>
              </limit>
            </limits>
          </rule>
        </rules>
      </configuration>
    </execution>
  </executions>
</plugin>
```

## Coverage Thresholds

| Metric | Minimum | Aspirational | Notes |
|--------|---------|-------------|-------|
| Line coverage | 80% | 90% | Baseline for quality gate |
| Branch coverage | 70% | 80% | Ensures conditional logic tested |
| Method coverage | 80% | 90% | Every public method exercised |
| Class coverage | 90% | 95% | No untested classes |

## Excluding Generated Code

### Lombok
Add to `lombok.config`:
```
lombok.addLombokGeneratedAnnotation = true
```
JaCoCo automatically skips classes/methods annotated with `@Generated`.

### MapStruct
MapStruct-generated `*Impl` classes are already annotated with `@Generated`.

### Explicit Exclusions
```xml
<configuration>
  <excludes>
    <exclude>**/config/**</exclude>
    <exclude>**/dto/**</exclude>
    <exclude>**/*Application.class</exclude>
    <exclude>**/*Config.class</exclude>
    <exclude>**/*Constants.class</exclude>
  </excludes>
</configuration>
```

## Multi-Module Reports

### Aggregate Report
```xml
<!-- In aggregator/pom.xml -->
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <executions>
    <execution>
      <id>report-aggregate</id>
      <phase>verify</phase>
      <goals><goal>report-aggregate</goal></goals>
    </execution>
  </executions>
</plugin>
```

## CI Integration

```yaml
# GitHub Actions
- name: Run Tests with Coverage
  run: ./mvnw clean verify

- name: Upload Coverage Report
  uses: actions/upload-artifact@v4
  with:
    name: jacoco-report
    path: target/site/jacoco/

- name: Fail on Low Coverage
  run: ./mvnw jacoco:check
```

## Coverage vs Quality

### What Coverage Tells You
- Which lines of code were executed during tests
- Which branches were taken
- Which methods were called

### What Coverage Does NOT Tell You
- Whether assertions are meaningful
- Whether edge cases are covered
- Whether the right behavior is tested
- Whether the test is reliable (not flaky)

### Coverage Anti-Patterns

| Anti-Pattern | Description | Fix |
|-------------|-------------|-----|
| **Coverage gaming** | Writing tests that execute code without asserting behavior | Review test quality, not just coverage numbers |
| **100% target** | Chasing 100% wastes time on trivial code | Set reasonable thresholds (80% line) |
| **Testing getters/setters** | Boilerplate tests for trivial code | Exclude DTOs/records from coverage |
| **Ignoring branch coverage** | High line coverage with untested conditionals | Set branch coverage threshold (70%) |
| **Coverage without CI gate** | Report generated but not enforced | `jacoco:check` in CI build |

## Viewing Reports

```bash
./mvnw clean verify jacoco:report
# Open: target/site/jacoco/index.html
```

The report shows:
- Package-level summary
- Class-level line/branch/method coverage
- Source view with green (covered) / red (uncovered) / yellow (partial branch) highlighting
