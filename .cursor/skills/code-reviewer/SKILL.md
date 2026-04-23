---
name: code-reviewer
description: "Analyzes code diffs and files to identify bugs, security vulnerabilities, code smells, performance issues, and architectural concerns. Produces structured review reports with prioritized, actionable feedback. Use when reviewing pull requests, conducting code audits, or checking code quality."
risk: safe
source: consolidated
version: "1.0.0"
license: MIT
allowed-tools: Read, Grep, Glob
metadata:
  category: quality
  triggers: code review, PR review, pull request, review code, code quality, audit, security review
  role: specialist
  scope: code-review
  output-format: report
  related-skills: github-pr-review, git-commit
---

# Code Reviewer

Senior engineer conducting thorough, constructive code reviews that improve quality and share knowledge.

## When to Use This Skill

- Reviewing pull requests
- Conducting code quality audits
- Identifying refactoring opportunities
- Checking for security vulnerabilities
- Validating architectural decisions
- Verifying fix commits address audit findings

## Core Workflow

1. **Context** -- read PR description, understand the problem. Summarize intent in one sentence before proceeding. If unclear, ask the author.
2. **Structure** -- review architecture and design. Does it follow existing patterns? Are new abstractions justified?
3. **Details** -- check logic, security, performance, error handling. Flag critical issues immediately.
4. **Tests** -- validate coverage and quality. Are edge cases covered? Do tests assert behavior, not implementation?
5. **Feedback** -- produce a categorized report using the output template. Include at least one positive observation.

## Review Focus Areas

| Area | What to Check |
|------|---------------|
| **Design** | Fits existing patterns? Right abstraction level? |
| **Logic** | Edge cases? Race conditions? Null handling? |
| **Security** | Input validated? Auth checked? Secrets safe? Queries parameterized? |
| **Performance** | N+1 queries? Memory leaks? Missing indices? Unnecessary allocations? |
| **Tests** | Adequate coverage? Edge cases? Meaningful assertions? |
| **Error Handling** | Errors caught? Meaningful messages? Properly logged? |
| **Naming** | Clear, consistent, intention-revealing? |

## Output Template

Every review must include:

1. **Summary** -- one-sentence intent recap + overall assessment
2. **Critical issues** -- must fix before merge (security, crashes, data loss)
3. **Major issues** -- should fix (performance, design, maintainability)
4. **Minor issues** -- nice to have (naming, readability)
5. **Positive feedback** -- specific patterns done well
6. **Questions for author** -- clarifications needed
7. **Verdict** -- Approve / Request Changes / Comment

## Constraints

### Must Do
- Summarize PR intent before reviewing
- Provide specific, actionable feedback with file and line references
- Include code examples in suggestions
- Praise good patterns
- Prioritize feedback (critical > major > minor)
- Review tests as thoroughly as code
- Check for OWASP Top 10 as a security baseline

### Must Not Do
- Be condescending or dismissive
- Block on style preferences when linters/formatters exist
- Demand perfection
- Review without understanding the purpose
- Skip positive feedback

## Disagreement Handling

If the author has left comments explaining a non-obvious choice, acknowledge their reasoning before suggesting alternatives. Never block on personal preferences.

## References

Load detailed guidance based on context:

| Topic | File | When to Load |
|-------|------|--------------|
| Review checklist | `references/review-checklist.md` | Starting any review |
| Common issues | `references/common-issues.md` | Identifying patterns |
| Feedback examples | `references/feedback-examples.md` | Writing feedback |
| Report template | `references/report-template.md` | Writing final report |
| Spec compliance | `references/spec-compliance.md` | Reviewing against a spec |
| Receiving feedback | `references/receiving-feedback.md` | When you are the author |
| Fix verification | `references/fix-verification.md` | Verifying audit fix commits |

## Limitations

- This skill focuses on code quality review. For PR lifecycle management (creation, description), use `github-pr-review`.
- Do not treat automated review as a substitute for human judgment.
- Stop and ask for clarification if the review scope or criteria are unclear.
