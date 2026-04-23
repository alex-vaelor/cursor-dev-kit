---
name: agile-workflow
description: "Use when creating agile artifacts -- including epics, features, user stories with Gherkin acceptance criteria, INVEST validation, and breakdown patterns."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: process
  triggers: epic, feature, user story, acceptance criteria, Gherkin, BDD, agile, INVEST, story splitting
  role: specialist
  scope: agile
  original-author: Juan Antonio Breña Moral
  related-skills: project-planning
---

# Agile Workflow

Create well-structured agile artifacts: epics, features, and user stories with Gherkin acceptance criteria.

## When to Use This Skill

- Create an agile epic with business value and breakdown
- Derive features from an epic with acceptance criteria
- Write user stories with Gherkin scenarios
- Validate stories against INVEST criteria
- Split large stories into smaller deliverables

## Epic -> Feature -> Story Flow

```
Epic (1-3 months, 3-7 features)
├── Feature (1-3 sprints, acceptance criteria)
│   ├── User Story (1-3 days, Gherkin scenarios, INVEST)
│   └── User Story
└── Feature
    └── User Story
```

## User Story Format

```
As a [persona],
I want to [goal],
So that [benefit].
```

## Gherkin Acceptance Criteria

```gherkin
Scenario: [Description]
  Given [precondition]
  When [action]
  Then [expected result]
```

## INVEST Validation

Every story must pass: Independent, Negotiable, Valuable, Estimable, Small, Testable.

## Constraints

- Epics: 3-7 features, completable in 1-3 months
- Features: completable in 1-3 sprints, link to parent epic
- Stories: max 8 story points, at least 2 acceptance criteria
- All acceptance criteria must be testable

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Epic template | `references/epic-template.md` | Creating epics |
| Feature template | `references/feature-template.md` | Deriving features |
| User story template | `references/user-story-template.md` | Writing stories |

## Related Rules

- `rules/agile/epics.mdc` -- epic definition
- `rules/agile/features.mdc` -- feature definition
- `rules/agile/user-stories.mdc` -- user story definition
- `rules/agile/planning.mdc` -- planning conventions
