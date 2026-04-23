---
name: spring-cloud
description: "Use when building or reviewing distributed Spring Boot applications -- including Spring Cloud Config, Eureka service discovery, Spring Cloud Gateway, Resilience4j circuit breakers, distributed tracing, and Kubernetes deployment."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: distributed-systems
  triggers: spring cloud, service discovery, eureka, config server, api gateway, circuit breaker, resilience4j, distributed tracing, micrometer, kubernetes, load balancer
  role: specialist
  scope: spring-cloud
  original-author: Juan Antonio Breña Moral
  related-skills: spring-boot-core, spring-boot-rest, spring-boot-security
---

# Spring Cloud

Build and manage distributed Spring Boot applications with Spring Cloud components.

## When to Use This Skill

- Set up centralized configuration (Spring Cloud Config)
- Implement service discovery (Eureka)
- Configure API gateway (Spring Cloud Gateway)
- Add resilience patterns (circuit breakers, retries, rate limiting)
- Set up distributed tracing (Micrometer Tracing + Zipkin/Jaeger)
- Deploy Spring Boot to Kubernetes with health probes
- Configure client-side load balancing

## Components

| Component | Purpose | When to Use |
|-----------|---------|-------------|
| Config Server | Centralized configuration | Multi-service config management |
| Eureka | Service discovery | Dynamic service registration |
| Gateway | API gateway | Routing, filtering, rate limiting |
| Resilience4j | Fault tolerance | Circuit breakers, retries, bulkheads |
| Micrometer Tracing | Distributed tracing | Request tracing across services |
| LoadBalancer | Client-side LB | Service-to-service communication |

## Constraints

- **MANDATORY**: Run `./mvnw compile` before and after configuration changes
- **VERIFY**: Run `./mvnw clean verify` after changes
- Every external call must have timeout, retry, and circuit breaker configuration
- Propagate correlation IDs in all inter-service communication
- Use health probes (`/actuator/health/liveness`, `/actuator/health/readiness`) for Kubernetes

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Spring Cloud guidelines | `references/cloud-guidelines.md` | When configuring Cloud components |

## Related Rules

- `rules/architecture/microservices.mdc` -- microservices patterns
- `rules/spring/core.mdc` -- Spring Boot core conventions

## Related Skills

- `skills/spring-boot-core/` -- Spring Boot fundamentals
- `skills/spring-boot-security/` -- securing distributed services
