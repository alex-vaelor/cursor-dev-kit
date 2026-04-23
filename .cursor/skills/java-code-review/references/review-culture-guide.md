# Code Review Culture Guide

## Purpose

Establish a healthy, constructive code review culture that improves code quality, shares knowledge, and strengthens the team.

## Principles of Good Reviews

### 1. Reviews Are Conversations, Not Gatekeeping
- Goal: improve the code collaboratively, not prove the reviewer is right
- Ask questions ("Could this be simplified?") rather than making demands ("Simplify this")
- Explain the "why" behind every suggestion

### 2. Review the Code, Not the Person
- Comment on the code, not the author: "This method could be extracted" not "You should have extracted this"
- Assume positive intent
- Acknowledge good decisions explicitly

### 3. Timeliness Matters
- Respond to review requests within 4 business hours (ideal: within 2)
- Long review turnaround blocks the entire team
- If you can't review in time, say so and suggest an alternative reviewer

### 4. Calibrate Review Depth to Risk

| Change Type | Review Depth | Reviewers |
|------------|-------------|-----------|
| Critical path / security / data | Deep, line-by-line | 2+ senior reviewers |
| Feature code | Standard review | 1-2 reviewers |
| Test-only changes | Focus on coverage and quality | 1 reviewer |
| Config / docs | Light review | 1 reviewer |
| Generated / boilerplate | Verify generation params | 1 reviewer |

## Constructive Feedback Patterns

### Effective Feedback Structure
```
[Severity] Observation → Rationale → Suggestion

Example:
[MAJOR] This `synchronized` block locks the entire collection during iteration.
Under concurrent writes, this can cause thread starvation for high-throughput endpoints.

Consider using ConcurrentHashMap or creating a defensive copy before iteration:
    var snapshot = List.copyOf(items);
    snapshot.forEach(this::process);
```

### Severity Tags

| Tag | Meaning | Action Required |
|-----|---------|-----------------|
| `[CRITICAL]` | Security hole, data loss, crash | Must fix before merge |
| `[MAJOR]` | Performance, design, or correctness issue | Should fix before merge |
| `[MINOR]` | Readability, naming, minor improvement | Nice to have |
| `[NIT]` | Style, formatting, trivial preference | Author's discretion |
| `[QUESTION]` | Need clarification, not a change request | Respond before merge |
| `[PRAISE]` | Something done well | No action needed |

### Language Patterns

**Instead of:**
- "This is wrong" → "I think this might not handle the case when..."
- "Why did you do this?" → "I'd like to understand the reasoning behind..."
- "This is too complex" → "Could we simplify this by extracting..."
- "Don't use this pattern" → "In our codebase, we prefer X pattern because..."

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Harmful | Fix |
|-------------|-----------------|-----|
| **Rubber stamping** | Misses bugs, erodes trust in reviews | Use a checklist; comment on at least 3 areas |
| **Nitpick blocking** | Demoralizes authors, wastes time | Use `[NIT]` tag; approve with nits noted |
| **Drive-by reviewing** | Incomplete reviews miss critical issues | Finish the entire review before submitting |
| **Gatekeeper syndrome** | Creates bottleneck on one person | Rotate reviewers; trust junior reviewers |
| **Style wars** | Wastes time on preferences | Enforce style with Checkstyle/Spotless; stop debating |
| **Delayed feedback** | Blocks delivery; context decays | Set review SLA (4h); use reminders |

## Knowledge Sharing Through Reviews

- Explain patterns you introduce, not just "use X"
- Link to documentation when referencing conventions
- Share relevant ADRs when design decisions come up
- Use reviews as teaching moments (especially for Java 17/21 features, modern Spring patterns)
- When suggesting a modernization (e.g., switch to record, use pattern matching), include a brief example

## Metrics for Review Health

| Metric | Healthy Range | How to Measure |
|--------|---------------|----------------|
| Time to first review | < 4 hours | PR creation → first comment |
| Review cycle time | < 24 hours | PR creation → approval |
| Review thoroughness | ≥3 areas covered per review | Count distinct review categories |
| Rework rate | < 20% of PRs need second revision | PRs with multiple review rounds |
| PR size | < 400 lines changed | `git diff --stat` |
