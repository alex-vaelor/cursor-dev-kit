---
name: project-planning
description: "Use when creating implementation plans -- including Cursor Plan mode, structured plans with YAML frontmatter, GitHub issues, sprint planning, estimation, and backlog management."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: process
  triggers: plan, implementation plan, cursor plan mode, sprint planning, estimation, backlog, GitHub issues, specification
  role: specialist
  scope: planning
  original-author: Juan Antonio Breña Moral
  related-skills: agile-workflow
---

# Project Planning

Create structured implementation plans, manage sprints, and organize work using Cursor Plan mode and GitHub issues.

## When to Use This Skill

- Create a Cursor Plan mode implementation plan
- Plan a sprint with stories and tasks
- Estimate work and manage backlog
- Create GitHub issues from planned work
- Structure a specification or design document

## Plan Mode Workflow

1. **Gather context**: Read existing code, understand constraints
2. **Draft plan**: YAML frontmatter (name, overview, todos), structured sections
3. **Validate**: Confirm scope with user
4. **Execute**: Work through todos; update status after each task
5. **Review**: Verify all acceptance criteria

### Plan File Structure

```
.cursor/plans/YYYY-MM-DD_<plan-name>.plan.md
```

Required sections: Requirements Summary, Approach (with diagram), Task List, Execution Instructions, File Checklist, Notes.

## Sprint Planning

- Sprint goal: one sentence describing what the sprint delivers
- Select stories that fit capacity
- Break into tasks (2-4 hours each)
- Account for tech debt budget (10-20%)

## Estimation

- Story points: Fibonacci scale (1, 2, 3, 5, 8, 13)
- Stories >8 points should be split
- Track velocity over 3+ sprints

## Constraints

- Plans must include Execution Instructions section
- Update plan status after completing each task
- Never advance to next task without updating status

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Plan mode template | `references/plan-mode-template.md` | Creating Cursor plans |
| GitHub issues workflow | `references/github-issues-workflow.md` | Creating issues from plans |

## Related Rules

- `rules/agile/planning.mdc` -- planning conventions
- `rules/agile/epics.mdc` -- epic definition
