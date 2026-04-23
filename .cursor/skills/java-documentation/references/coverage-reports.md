# Documentation Coverage Reports

## Purpose

Track and improve documentation completeness across a Java project. This template helps identify undocumented public APIs, missing package descriptions, and stale documentation.

## Javadoc Coverage Report

### Generating the Report
```bash
# Maven Javadoc plugin -- generates report with missing docs highlighted
./mvnw javadoc:javadoc -Dshow=public -DfailOnWarnings=false
# Report at: target/site/apidocs/

# Count Javadoc warnings (missing docs)
./mvnw javadoc:javadoc 2>&1 | grep -c "warning"
```

### Coverage Metrics

| Metric | How to Measure | Target |
|--------|---------------|--------|
| Public class Javadoc | Classes without `/** */` above declaration | 100% |
| Public method Javadoc | Methods without Javadoc | 100% for API, 90% for internal |
| `@param` coverage | Methods with Javadoc but missing `@param` for parameters | 100% |
| `@return` coverage | Methods with Javadoc but missing `@return` | 100% (non-void) |
| `@throws` coverage | Methods declaring checked exceptions without `@throws` | 100% |
| `package-info.java` | Packages without `package-info.java` | 100% |
| `module-info.java` | Modules without `module-info.java` | 100% (modular projects) |

## Report Template

```markdown
# Documentation Coverage Report

**Project**: [project-name]
**Date**: [YYYY-MM-DD]
**Analyzer**: [name/tool]

## Summary
- **Total public classes**: X
- **Documented classes**: Y (Z%)
- **Total public methods**: X
- **Documented methods**: Y (Z%)
- **Javadoc warnings**: N

## Missing Documentation

### Classes Without Javadoc
| Package | Class | Priority |
|---------|-------|----------|
| com.example.order.service | OrderService | High |

### Methods Without Javadoc
| Class | Method | Priority |
|-------|--------|----------|
| OrderService | createOrder(OrderRequest) | High |

### Packages Without package-info.java
| Package | Description Needed |
|---------|-------------------|
| com.example.order | Order domain root |

## Stale Documentation
| File | Last Modified | Issue |
|------|---------------|-------|
| README.md | 2024-01-15 | Missing new module docs |

## Recommendations
1. [Specific actionable recommendations]
```

## Checkstyle Javadoc Rules
```xml
<module name="JavadocType">
  <property name="scope" value="public"/>
</module>
<module name="JavadocMethod">
  <property name="accessModifiers" value="public"/>
  <property name="allowMissingParamTags" value="false"/>
  <property name="allowMissingReturnTag" value="false"/>
</module>
<module name="MissingJavadocType">
  <property name="scope" value="public"/>
</module>
<module name="MissingJavadocMethod">
  <property name="minLineCount" value="0"/>
  <property name="allowedAnnotations" value="Override"/>
  <property name="scope" value="public"/>
</module>
```

## CI Integration
```yaml
- name: Javadoc Coverage Check
  run: |
    WARNING_COUNT=$(./mvnw javadoc:javadoc 2>&1 | grep -c "warning" || true)
    echo "Javadoc warnings: $WARNING_COUNT"
    if [ "$WARNING_COUNT" -gt 0 ]; then
      echo "::warning::$WARNING_COUNT Javadoc warnings found"
    fi
```
