---
name: java-observability
description: "Use when implementing or reviewing Java logging, metrics, and observability -- including SLF4J, structured logging, MDC correlation, log levels, OpenTelemetry, health checks, and monitoring patterns."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: logging, observability, SLF4J, MDC, structured logging, metrics, tracing, OpenTelemetry, health check, monitoring
  role: specialist
  scope: java-observability
  original-author: Juan Antonio Breña Moral
  related-skills: java-performance, java-exception-handling
---

# Java Observability and Logging

Review and implement logging and observability patterns for production Java applications.

## When to Use This Skill

- Review logging practices and conventions
- Implement structured logging with SLF4J
- Set up MDC correlation for request tracing
- Configure log levels and appenders
- Implement health checks and metrics endpoints
- Set up OpenTelemetry tracing

## Coverage

- SLF4J as logging facade: parameterized messages, logger naming
- Structured logging: JSON format, key-value pairs
- MDC (Mapped Diagnostic Context) for correlation/request IDs
- Log levels: ERROR, WARN, INFO, DEBUG, TRACE usage guidelines
- What to log and what NOT to log (PII, secrets)
- Performance-aware logging: guards, lazy evaluation, async appenders
- Health checks and readiness/liveness probes
- Metrics collection and exposure

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full logging guidelines | `references/logging-guidelines.md` | Before any logging review |
| Structured logging patterns | `references/structured-logging-patterns.md` | When implementing JSON/structured logging |

## Related Rules

- `rules/java/logging.mdc` -- logging conventions
