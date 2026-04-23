---
name: spring-actuator-monitoring
description: "Use when configuring Spring Boot Actuator and Micrometer monitoring -- including endpoint exposure and security, custom health indicators, business metrics, Kubernetes probes, Prometheus export, and observability patterns."
risk: safe
source: new
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: observability
  triggers: actuator, health check, metrics, Micrometer, Prometheus, Grafana, monitoring, observability, counter, timer, gauge, Kubernetes probes, liveness, readiness
  role: specialist
  scope: spring-actuator
  related-skills: spring-boot-core, java-observability, error-debugging
---

# Spring Boot Actuator & Monitoring

Configure production-ready monitoring with Spring Boot Actuator and Micrometer.

## When to Use This Skill

- Configure Actuator endpoints for production
- Secure Actuator endpoints (never expose all publicly)
- Create custom health indicators for external dependencies
- Implement business metrics with Micrometer
- Set up Kubernetes liveness/readiness probes
- Export metrics to Prometheus/Grafana
- Define SLO-based alerting thresholds

## Constraints

- **NEVER** expose all Actuator endpoints in production
- **ALWAYS** secure sensitive endpoints (env, beans, heapdump)
- **ALWAYS** use low-cardinality tags on metrics
- **VERIFY** health indicators don't cause cascading failures (timeouts, circuit breakers)

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Actuator configuration guide | `references/actuator-guide.md` | Setting up Actuator |
| Micrometer patterns | `references/micrometer-patterns.md` | Implementing custom metrics |

## Related Rules

- `rules/spring/actuator.mdc` -- Actuator conventions
- `rules/spring/aop.mdc` -- AOP for metrics aspects

## Related Skills

- `skills/spring-boot-core/` -- Spring Boot fundamentals
- `skills/java-observability/` -- logging and structured observability
- `skills/error-debugging/` -- incident response with Actuator
