# Receiving Code Review Feedback

## Core Mindset

Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## The Six-Step Process

### 1. Read Completely
Read the entire comment before forming any response.

### 2. Restate Requirements
Rephrase the feedback in your own words to confirm understanding:
> "You're suggesting I split this into three separate functions: validate(), transform(), and persist()?"

### 3. Check Against Codebase
Verify the feedback against actual code before responding.

### 4. Evaluate Technical Soundness
Consider whether the feedback applies to your specific stack and context.

### 5. Respond with Substance
Provide technical acknowledgment or reasoned objection:
- "Fixed. Split into validate(), transform(), persist() at lines 24, 45, 67."
- "Respectfully disagree. This list has max 5 items (see OrderItem.java:12), so filter performance is O(5)."

### 6. Implement One at a Time
Address each piece of feedback individually with verification.

## Response Patterns

| Situation | Response |
|-----------|----------|
| Reviewer is correct | "Fixed. [What you changed]." |
| Need clarification | "To confirm: you're suggesting [restatement]?" |
| Reviewer is incorrect | "This works because [evidence]. [Link to proof]." |
| Disagree on approach | "This conflicts with [X]. Should we [alternative]?" |
| Learned something | "I wasn't aware of [X]. Fixed at line [N]." |
| Cannot verify | "Implemented. Unable to verify because [reason]." |

## When to Push Back

Push back with technical reasoning when feedback:
- Breaks existing functionality (cite the test)
- Lacks codebase context (cite the architecture doc)
- Violates YAGNI (cite that only one caller exists)
- Is technically incorrect (cite the documentation)

### Pushback Format
> This conflicts with [X]. [Evidence]. Was that the intent, or should we [alternative]?

## Verification Before Claiming Fixed

Before writing "Fixed" or "Done":
- [ ] Change is implemented
- [ ] Tests pass (full suite)
- [ ] Specific behavior verified
- [ ] Edge cases tested
- [ ] No unintended side effects

## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Defensive responses | Creates conflict | Assume good faith, respond technically |
| Performative agreement | Adds noise | Just fix it and confirm |
| Delayed responses | Blocks cycle | Respond within hours |
| Vague responses | Leaves uncertainty | Be specific about changes |
| Ignoring feedback | Creates friction | Address every point |

*Content adapted from [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent (@obra), MIT License.*
