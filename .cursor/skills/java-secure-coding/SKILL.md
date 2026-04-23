---
name: java-secure-coding
description: "Use when applying Java secure coding practices -- including input validation, SQL injection prevention, secure deserialization, secrets management, cryptography best practices, dependency vulnerability scanning, and secure error handling."
risk: critical
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: security, secure coding, injection, XSS, OWASP, CVE, vulnerability, secrets, authentication, authorization
  role: specialist
  scope: java-security
  original-author: Juan Antonio Breña Moral
  related-skills: java-exception-handling, spring-boot-core
---

# Java Secure Coding

Review and improve Java code using secure coding practices aligned with OWASP guidelines.

## When to Use This Skill

- Review Java code for security vulnerabilities
- Apply secure coding standards
- Prevent injection attacks (SQL, LDAP, OS command)
- Implement proper secrets management
- Review cryptography usage
- Scan for dependency vulnerabilities

## Coverage

- Input validation and sanitization
- SQL injection prevention with parameterized queries
- Secure deserialization practices
- Secrets management (environment variables, vault services)
- Cryptography: TLS, secure random, key sizes
- Authentication and authorization patterns
- Secure error handling (no sensitive data in responses)
- Dependency vulnerability scanning (OWASP Dependency-Check)

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements
- **BEFORE APPLYING**: Read the reference for detailed examples and constraints

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full secure coding guidelines | `references/secure-coding-guidelines.md` | Before any security review |
| JWT security patterns | `references/jwt-security-patterns.md` | When implementing or reviewing JWT authentication |

## Related Rules

- `rules/java/secure-coding.mdc` -- secure coding rules
- `rules/security/application-security.mdc` -- application security
- `rules/security/api-security.mdc` -- API security
