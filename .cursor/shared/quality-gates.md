# Quality Gates

Quality gates define the minimum thresholds a Java project must meet before code can be merged or released. These are enforced through build plugins, CI/CD checks, and code review.

## Build Gate (Must Pass)

| Check | Tool | Threshold | Blocking |
|-------|------|-----------|----------|
| Compilation | `javac` (via Maven/Gradle) | Zero errors | Yes |
| Unit tests | JUnit + Maven Surefire | 100% pass | Yes |
| Integration tests | JUnit + Maven Failsafe | 100% pass | Yes |
| Code formatting | Checkstyle or Spotless | Zero violations | Yes |

## Coverage Gate

| Metric | Tool | Threshold | Blocking |
|--------|------|-----------|----------|
| Line coverage | JaCoCo | >= 80% (new code: >= 90%) | Yes |
| Branch coverage | JaCoCo | >= 70% (new code: >= 80%) | Yes |
| Mutation score | PIT (optional) | >= 60% | Advisory |

### Coverage Exclusions
- Configuration classes (`*Config.java`)
- Spring Boot main application class
- Generated code (OpenAPI, MapStruct, Lombok)
- DTOs/records with no business logic

## Static Analysis Gate

| Check | Tool | Threshold | Blocking |
|-------|------|-----------|----------|
| Bug patterns | SpotBugs | Zero HIGH/CRITICAL | Yes |
| Code smells | PMD or SonarQube | Zero BLOCKER/CRITICAL | Yes |
| Style violations | Checkstyle | Zero violations | Yes |
| Dependency vulnerabilities | OWASP Dependency-Check | Zero HIGH/CRITICAL CVEs | Yes |

## Architecture Gate

| Check | Method | Threshold | Blocking |
|-------|--------|-----------|----------|
| Package dependencies | ArchUnit | No circular dependencies | Yes |
| Layer violations | ArchUnit | Controllers do not access repositories directly | Yes |
| Naming conventions | ArchUnit | All classes follow naming rules | Advisory |

## PR Gate (Code Review)

| Check | Method | Threshold | Blocking |
|-------|--------|-----------|----------|
| Reviewer approval | GitHub PR review | >= 1 approval | Yes |
| No critical findings | Human review | Zero unresolved critical issues | Yes |
| Tests for new code | Human review | New behavior has tests | Yes |
| No secrets committed | GitHub secret scanning / pre-commit hook | Zero findings | Yes |

## Release Gate

| Check | Method | Threshold | Blocking |
|-------|--------|-----------|----------|
| All PR gates pass | CI/CD pipeline | 100% | Yes |
| CHANGELOG updated | Human/automated check | Entry exists for version | Yes |
| Version tag valid | SemVer validation | Follows MAJOR.MINOR.PATCH | Yes |
| No snapshot dependencies | Maven Enforcer / Gradle check | Zero SNAPSHOT deps in release | Yes |

## Enforcement

### Maven Integration
```xml
<!-- Enforcer plugin for build-time gates -->
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-enforcer-plugin</artifactId>
  <executions>
    <execution>
      <goals><goal>enforce</goal></goals>
      <configuration>
        <rules>
          <requireMavenVersion><version>3.9</version></requireMavenVersion>
          <requireJavaVersion><version>17</version></requireJavaVersion>
          <banDuplicatePomDependencyVersions/>
          <reactorModuleConvergence/>
        </rules>
      </configuration>
    </execution>
  </executions>
</plugin>
```

### CI/CD Pipeline
Quality gates should be enforced in CI as GitHub Actions status checks or equivalent. A PR cannot merge unless all blocking gates pass. See `skills/github-automation/` for workflow templates.
