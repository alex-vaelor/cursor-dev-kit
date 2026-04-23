---
name: docker-containers
description: "Use when working with Docker -- including Dockerfile optimization, multi-stage builds, container security, Docker Compose orchestration, image size optimization, and development workflow integration."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: devops
  triggers: Docker, Dockerfile, container, docker-compose, multi-stage build, container security, image optimization, distroless
  role: specialist
  scope: docker
  related-skills: bash-scripting
---

# Docker Containers

Build, optimize, and secure Docker containers for Java and general application deployment.

## When to Use This Skill

- Write or optimize Dockerfiles (multi-stage builds)
- Configure Docker Compose for development and production
- Harden container security (non-root, secrets, minimal images)
- Optimize image size (distroless, Alpine, layer caching)
- Set up development workflow with hot reload
- Debug container issues (networking, volumes, health checks)

## Key Patterns

### Multi-Stage Build (Java)
- Build stage: JDK + Maven for compilation
- Runtime stage: JRE-only or distroless for minimal footprint
- Copy only artifacts needed at runtime

### Security
- Non-root user with explicit UID/GID
- BuildKit secrets for build-time credentials
- Vulnerability scanning (Docker Scout, Trivy)
- Minimal base images (distroless preferred for production)

### Compose
- Health checks on all services
- Custom networks for isolation
- Resource limits in production
- Environment-specific overrides

## Constraints

- Never use `:latest` tag in production Dockerfiles
- Always run as non-root user
- Always include `.dockerignore`
- Health checks on every production service
- Scan images for vulnerabilities before deployment

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Docker expert patterns | `references/docker-patterns.md` | Dockerfile optimization, Compose, security |

## Related Rules

- `rules/docker/containers.mdc` -- general Docker conventions
- `rules/docker/java-containers.mdc` -- Java-specific containers

## Related Skills

- `skills/bash-scripting/` -- helper scripts for Docker workflows
