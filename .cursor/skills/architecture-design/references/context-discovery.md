# Architecture Context Discovery

## Purpose

Before selecting patterns or making design decisions, thoroughly understand the system context: stakeholders, constraints, quality attributes, and existing landscape.

## Context Discovery Checklist

### 1. Stakeholder Analysis

| Stakeholder | Concern | Quality Attribute |
|-------------|---------|-------------------|
| End users | Response time, reliability | Performance, Availability |
| Operations | Deployability, monitoring | Operability, Observability |
| Security team | Data protection, compliance | Security, Auditability |
| Development team | Maintainability, testability | Modifiability, Testability |
| Business owners | Time to market, cost | Agility, Cost efficiency |

### 2. Functional Scope

- **Core use cases**: What must the system do?
- **Data model sketch**: Key entities and relationships
- **Integration points**: External systems, APIs, data sources
- **User volume**: Concurrent users, request rates, data growth

### 3. Constraint Discovery

| Constraint Type | Questions |
|----------------|-----------|
| **Technology** | Mandated tech stack? Cloud provider? Java version? |
| **Organizational** | Team size? Skill set? Deployment cadence? |
| **Regulatory** | GDPR? PCI-DSS? SOC 2? Data residency? |
| **Timeline** | MVP deadline? Phased rollout? |
| **Budget** | Infrastructure budget? Licensing? |

### 4. Quality Attribute Prioritization

Rank quality attributes using trade-off analysis. These compete:

| Trade-Off | Explanation |
|-----------|-------------|
| Performance vs Security | Encryption adds latency; input validation adds overhead |
| Consistency vs Availability | CAP theorem -- choose for each operation |
| Simplicity vs Flexibility | Abstractions add complexity |
| Time to market vs Quality | Shortcuts now become tech debt later |

## Spring Boot Context Example

For a typical Spring Boot 4 backend:

```
System: Order Management Service

Stakeholders:
- Frontend team (REST API consumers)
- Operations (Kubernetes deployment, monitoring)
- Security (PCI-DSS for payment data)

Constraints:
- Java 21, Spring Boot 4.0.x, PostgreSQL 16
- Deploy to Kubernetes on AWS EKS
- Must integrate with legacy ERP (SOAP) and payment gateway (REST)
- Team of 5 backend developers

Quality Attributes (ranked):
1. Correctness -- financial transactions must be accurate
2. Security -- PCI-DSS compliance for payment data
3. Availability -- 99.9% uptime SLA
4. Performance -- <200ms p95 for order creation
5. Maintainability -- team must onboard new devs quickly
```

## From Context to Architecture Decisions

| Context Signal | Suggests |
|---------------|----------|
| Single team, <10 services | Modular monolith over microservices |
| Multiple teams, independent release cycles | Microservices |
| Complex domain with many business rules | DDD tactical patterns, hexagonal architecture |
| High read:write ratio | CQRS for read optimization |
| Event-driven integrations | Event sourcing, message broker |
| Strict consistency requirements | Synchronous calls, 2PC or saga with compensation |
| Compliance/audit requirements | Event sourcing (immutable log), audit tables |

## Output: Context Document

```markdown
# Architecture Context: [System Name]

## Mission Statement
[One sentence: what does this system do and for whom?]

## Stakeholders
[Table from analysis above]

## Key Constraints
[Bulleted list of hard constraints]

## Quality Attribute Priorities
[Ranked list with rationale]

## Integration Landscape
[Diagram or list of external systems]

## Decision Drivers
[What factors will most influence architecture choices?]
```
