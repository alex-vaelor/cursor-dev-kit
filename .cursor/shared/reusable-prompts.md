# Reusable Prompt Fragments

Prompt fragments used by agents and skills. Reference these to maintain consistency.

## Pre-Action Safety Check

```
Before making any changes:
1. Run `git status` to understand the current state
2. Verify you are on the correct branch
3. Ensure there are no uncommitted changes that could be lost
4. Create a backup branch if the operation is destructive
```

## Commit Message Generation

```
Generate a commit message following conventional format:
- Type: feat|fix|docs|style|refactor|perf|test|build|ci|chore
- Scope: the module or area affected (optional)
- Subject: imperative, capitalized, no period, max 72 chars
- Body: explain what and why, not how
- Footer: issue references (Fixes #N) and breaking changes
```

## PR Description Generation

```
Analyze the diff and generate a PR description with:
1. Summary: one paragraph explaining what changed and why
2. Changes table: category, files, key change
3. Testing: what was tested and how
4. Risks: breaking changes, risk level, rollback plan
5. Self-review checklist
```

## Code Review Dispatch

```
Review this code change for:
1. Spec compliance: does it implement the requirements?
2. Design: does it fit existing patterns?
3. Logic: edge cases, null handling, race conditions?
4. Security: input validation, auth, injection risks?
5. Performance: N+1 queries, memory leaks, missing indices?
6. Tests: coverage, quality, edge cases?

Output a structured report with severity tags:
[CRITICAL], [MAJOR], [MINOR], [NIT], [QUESTION], [PRAISE]
```

## Version Determination

```
Analyze commits since the last tag to determine the next version:
- BREAKING CHANGE or feat! -> bump MAJOR
- feat -> bump MINOR
- fix -> bump PATCH
- docs, test, chore -> no version bump
```

## Branch Validation

```
Validate the branch name against the pattern:
  <type>/<ticket-id>-<description>

Types: feature, bugfix, hotfix, release, chore, docs, refactor, test, experiment
Rules: lowercase, hyphens only, no underscores or spaces, under 100 chars total.
```
