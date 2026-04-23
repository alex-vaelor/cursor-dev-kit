# Cross-Cutting Conventions

## Naming Conventions

### Files and Directories
- Use kebab-case for directories: `git-workflow`, `code-reviewer`
- Use UPPER_CASE for entry points: `SKILL.md`, `AGENTS.md`
- Use kebab-case for reference files: `branching-strategies.md`
- Use kebab-case for scripts: `validate-branch-name.sh`

### .cursor Structure
- Rules: `.cursor/rules/<domain>/<rule-name>.mdc`
- Skills: `.cursor/skills/<skill-name>/SKILL.md`
- Agents: `.cursor/agents/<agent-name>.md`
- Templates: `.cursor/templates/<template-name>.md`
- Shared: `.cursor/shared/<resource-name>.md`

### Skill Directories
Each skill follows this structure:
```
<skill-name>/
  SKILL.md              # Main entry point (required)
  references/           # Supporting docs, standards, guides
  scripts/              # Helper scripts, validators
  assets/               # Examples, templates, diagrams
```

## Document Formatting

### SKILL.md Frontmatter
Every SKILL.md must have YAML frontmatter:
```yaml
---
name: skill-name              # Must match directory name
description: "Use when..."    # Trigger-oriented description
risk: safe|critical|unknown   # Risk assessment
source: consolidated|community
version: "1.0.0"
metadata:
  category: workflow|quality|automation|meta
  triggers: keyword1, keyword2, keyword3   # 3+ triggers
  role: specialist|assistant
  scope: description-of-scope
  related-skills: other-skill-1, other-skill-2
---
```

### Rule (.mdc) Frontmatter
```yaml
---
description: What this rule enforces
globs: ["**/.git/**"]          # File patterns for auto-activation
alwaysApply: false             # true only for universal rules
---
```

### Agent (.md) Structure
```markdown
# Agent Name

## Identity
## Scope
## Tools
## Behavior
## Constraints
## Related Rules
## Related Skills
```

## Cross-References

- Rules reference other rules by path: `rules/git/workflow.mdc`
- Skills reference their own files relatively: `references/guide.md`
- Agents reference both rules and skills by path
- Never use `@` force-loading in cross-references
- Keep total SKILL.md under 500 lines; split excess into `references/`
