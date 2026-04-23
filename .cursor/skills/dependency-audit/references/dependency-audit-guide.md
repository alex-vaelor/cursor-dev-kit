# Dependency Audit Guide for Java/Maven Projects

## Step 1: Dependency Inventory

### Generate Full Dependency Tree
```bash
./mvnw dependency:tree -Dverbose > dependency-tree.txt
```

Review for:
- Unexpected transitive dependencies
- Multiple versions of the same artifact (version conflicts)
- Large dependency trees indicating bloat

### Detect Unused and Undeclared Dependencies
```bash
./mvnw dependency:analyze
```
- **Used undeclared**: Add explicit `<dependency>` declaration
- **Unused declared**: Remove if truly unused; verify with compilation

## Step 2: Vulnerability Scanning

### OWASP Dependency-Check (Maven)
```xml
<plugin>
  <groupId>org.owasp</groupId>
  <artifactId>dependency-check-maven</artifactId>
  <version>10.0.4</version>
  <configuration>
    <failBuildOnCVSS>7</failBuildOnCVSS>
    <suppressionFiles>
      <suppressionFile>dependency-check-suppressions.xml</suppressionFile>
    </suppressionFiles>
  </configuration>
</plugin>
```

```bash
./mvnw dependency-check:check
```

### Severity Response Matrix

| CVSS Score | Severity | Action | Timeline |
|-----------|----------|--------|----------|
| 9.0-10.0 | Critical | Patch immediately or remove dependency | Same day |
| 7.0-8.9 | High | Patch in current sprint | Within 1 week |
| 4.0-6.9 | Medium | Plan upgrade | Within 1 month |
| 0.1-3.9 | Low | Track and batch with next update | Next quarter |

### Suppression File (for false positives)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<suppressions xmlns="https://jeremylong.github.io/DependencyCheck/dependency-suppression.1.3.xsd">
  <suppress>
    <notes>False positive: CVE applies to server-side use only; we use client-side only</notes>
    <cve>CVE-2024-XXXXX</cve>
  </suppress>
</suppressions>
```

## Step 3: License Compliance

### Common License Categories

| License | Commercial Use | Notes |
|---------|---------------|-------|
| Apache 2.0 | Safe | Most Spring ecosystem |
| MIT | Safe | Minimal restrictions |
| BSD | Safe | Minimal restrictions |
| EPL 2.0 | Safe with care | Eclipse ecosystem; check secondary license |
| LGPL 2.1/3.0 | Usually safe | Dynamic linking OK; no modifications to LGPL code |
| GPL 2.0/3.0 | **Restricted** | Copyleft; legal review required for proprietary projects |

### Automated License Checking
```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>license-maven-plugin</artifactId>
  <version>2.4.0</version>
  <executions>
    <execution>
      <goals><goal>add-third-party</goal></goals>
    </execution>
  </executions>
</plugin>
```

```bash
./mvnw license:add-third-party
# Review: target/generated-sources/license/THIRD-PARTY.txt
```

## Step 4: Freshness Check

```bash
./mvnw versions:display-dependency-updates
./mvnw versions:display-plugin-updates
./mvnw versions:display-property-updates
```

### Update Strategy
- **Patch versions** (1.2.3 -> 1.2.4): Apply immediately; usually bug fixes
- **Minor versions** (1.2.x -> 1.3.0): Test thoroughly; may add features
- **Major versions** (1.x -> 2.0): Plan migration; expect breaking changes

### Automated Updates
Configure Renovate or Dependabot for automated dependency PRs:
```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: maven
    directory: /
    schedule:
      interval: weekly
    open-pull-requests-limit: 10
```

## Step 5: Dependency Convergence

### Maven Enforcer Plugin
```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-enforcer-plugin</artifactId>
  <executions>
    <execution>
      <goals><goal>enforce</goal></goals>
      <configuration>
        <rules>
          <dependencyConvergence/>
          <requireMavenVersion>
            <version>[3.9,)</version>
          </requireMavenVersion>
          <requireJavaVersion>
            <version>[21,)</version>
          </requireJavaVersion>
          <banDuplicatePomDependencyVersions/>
        </rules>
      </configuration>
    </execution>
  </executions>
</plugin>
```

### Resolving Conflicts
When two dependencies require different versions of the same library:
1. Check `dependency:tree -Dverbose` to find the conflict
2. Use `<dependencyManagement>` to pin the desired version
3. Verify both dependents work with the pinned version
4. Add an integration test covering both code paths

## Step 6: Supply Chain Security

- Pin dependency versions exactly (no version ranges)
- Use Spring Boot BOM for consistent Spring ecosystem versions
- Verify artifact checksums in CI
- Enable GitHub secret scanning and Dependabot alerts
- Review new transitive dependencies when upgrading direct dependencies

## CI Integration

```yaml
# GitHub Actions step
- name: Dependency Security Audit
  run: ./mvnw dependency-check:check -DfailBuildOnCVSS=7

- name: License Check
  run: ./mvnw license:add-third-party

- name: Dependency Convergence
  run: ./mvnw enforcer:enforce
```
