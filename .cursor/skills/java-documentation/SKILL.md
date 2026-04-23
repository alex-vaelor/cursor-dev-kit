---
name: java-documentation
description: "Use when reviewing or writing Java documentation -- including Javadoc conventions, package-info, module-info, README structure, and documentation quality standards for classes, methods, and APIs."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: javadoc, documentation, package-info, module-info, README, API docs
  role: specialist
  scope: java-documentation
  original-author: Juan Antonio Breña Moral
  related-skills: java-oop-design
---

# Java Documentation

Review and improve Java documentation using Javadoc and project documentation best practices.

## When to Use This Skill

- Review Javadoc quality on classes and methods
- Write package-level and module-level documentation
- Establish documentation standards for a project
- Generate and review API documentation

## Coverage

- Javadoc conventions: `@param`, `@return`, `@throws`, `@since`, `@see`
- Class-level documentation: purpose, usage examples, thread safety notes
- Method-level documentation: contract, preconditions, postconditions
- Package-info.java: package purpose and JSpecify null-safety annotations
- Module-info.java: module declarations and exports
- When to document vs when code should be self-explanatory

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full documentation guidelines | `references/documentation-guidelines.md` | Before any documentation review |
| Documentation coverage reports | `references/coverage-reports.md` | When auditing documentation completeness |
| Doc generation patterns | `references/doc-generation-patterns.md` | When setting up Javadoc, OpenAPI, or site generation |
| Documentation templates | `references/documentation-templates.md` | README, ADR, CHANGELOG, CONTRIBUTING templates |
