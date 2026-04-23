---
name: architecture-design
description: "Use when designing system architecture -- including ADR authoring, C4 diagrams, pattern selection (layered, hexagonal, CQRS, event sourcing, microservices), NFR assessment, technology trade-off analysis, and architecture reviews."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: architecture
  triggers: architecture, system design, ADR, C4 diagram, architectural pattern, NFR, non-functional requirements, trade-off analysis, scalability, architecture review
  role: specialist
  scope: architecture
  related-skills: ddd-patterns, spring-boot-core, api-design
---

# Architecture Design

Design, document, and review system architecture with ADRs, C4 diagrams, and pattern selection.

## When to Use This Skill

- Design new system architecture or review existing designs
- Write Architecture Decision Records (ADRs)
- Create C4 model diagrams (Context, Container, Component)
- Select between architectural patterns (layered, hexagonal, CQRS, event sourcing)
- Assess non-functional requirements (NFR)
- Evaluate technology choices with trade-off analysis
- Conduct architecture reviews

## Workflow

1. **Requirements**: Gather functional and non-functional requirements
2. **Patterns**: Match requirements to architectural patterns
3. **Design**: Create architecture with explicit trade-offs
4. **Diagram**: Produce C4 diagrams (Level 1-3, never Level 4)
5. **Document**: Write ADRs for all significant decisions
6. **Review**: Validate with stakeholders

## Constraints

- Document all significant decisions with ADRs
- Consider non-functional requirements explicitly
- Evaluate trade-offs, not just benefits
- Plan for failure modes and operational complexity
- Do not over-engineer for hypothetical scale

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Architecture patterns | `references/architecture-patterns.md` | Selecting architecture style |
| ADR template | `references/adr-template.md` | Writing decision records |
| System design workflow | `references/system-design.md` | Full system design |
| NFR checklist | `references/nfr-checklist.md` | Gathering requirements |
| Database selection | `references/database-selection.md` | Choosing data stores |
| Context discovery | `references/context-discovery.md` | Understanding system context before design |
| Pattern selection trees | `references/pattern-selection.md` | Decision trees for pattern selection |
| Patterns quick reference | `references/patterns-reference.md` | Comparing patterns side-by-side |
| Architecture principles | `references/architecture-principles.md` | Clean Architecture, 12-Factor, SOLID at system level |

## Related Rules

- `rules/architecture/adr.mdc` -- ADR conventions
- `rules/architecture/diagrams.mdc` -- diagram conventions
- `rules/architecture/design-patterns.mdc` -- architecture patterns
- `rules/architecture/microservices.mdc` -- microservices patterns

## Related Skills

- `skills/ddd-patterns/` -- domain-driven design
- `skills/api-design/` -- API design
- `skills/database-design/` -- database design
