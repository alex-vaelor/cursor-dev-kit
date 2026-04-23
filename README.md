# .cursor/ — Java Development AI Toolkit

Production-ready rules, skills, agents, templates, and shared resources for modern Java 17/21 and Spring Boot 4.x development inside **Cursor IDE**.

---

## Directory Structure

```
.cursor/
├── rules/          64 .mdc rule files across 12 categories
├── skills/         46 skill packages (SKILL.md + references/ + scripts/)
├── agents/         13 agent definitions
├── templates/       9 reusable issue/PR/ADR templates
├── shared/          7 cross-cutting conventions and standards
└── docs/            4 detailed reference catalogs + prompt examples
```

---

## Quick Start

1. **Open this project in Cursor IDE.** Rules, skills, and agents activate automatically based on file globs and context.
2. **Edit a `.java` file** — rules like `java/coding-standards.mdc` and `java/modern-features.mdc` are applied by the AI when the file matches their glob patterns.
3. **Ask Cursor to help** — mention trigger keywords (e.g. "write a unit test", "review this PR", "set up Docker") and the matching skill is loaded automatically.
4. **Reference an agent** — agents define personas (e.g. `java-reviewer`, `spring-boot-engineer`) that combine rules and skills into focused workflows.

---

## How Rules Work

Rules are `.mdc` (Markdown with Configuration) files in `rules/`. Each rule has YAML frontmatter:

```yaml
---
description: Short description shown in Cursor UI
globs: ["**/*.java"]       # file patterns that activate this rule
alwaysApply: false         # true = always active regardless of file
---
```

**When they activate:**
- **Glob-based rules** activate when you open or edit a file matching the glob pattern. For example, `rules/java/coding-standards.mdc` activates for any `**/*.java` file.
- **Always-apply rules** (only `core/project-conventions.mdc`) are active in every context.
- **Empty-glob rules** (e.g. `behaviour/consultative.mdc`) are available but only used when explicitly referenced or when the AI determines they are relevant.

**Categories:**

| Category | Count | Focus |
|----------|-------|-------|
| Java | 12 | Coding standards, modern features, types, exceptions, concurrency, generics, functional, logging, security, Lombok, Jackson, MapStruct |
| Spring | 15 | Core, REST, data access, JPA/Hibernate, security, testing (3), migrations, retry/cache, AOP, Actuator, validation, GraphQL |
| Testing | 5 | Strategy, unit, integration, acceptance, TDD |
| Architecture | 5 | ADR, DDD, design patterns, diagrams, microservices |
| Security | 2 | Application security, API security |
| SQL | 3 | Database design, query optimization, migrations |
| Build | 3 | Maven, Gradle, Maven documentation |
| Git | 7 | Workflow, commits, branches, PRs, code review, GitHub, repo hygiene |
| Docker | 2 | General containers, Java containers |
| Core | 4 | Project conventions, code quality, documentation, AGENTS.md |
| Agile | 4 | Epics, features, user stories, planning |
| Bash | 1 | Shell scripting conventions |
| Behaviour | 2 | Consultative mode, progressive learning |

See [docs/rules-reference.md](.cursor/docs/rules-reference.md) for the complete catalog.

---

## How Skills Work

Skills are packaged expertise in `skills/<skill-name>/`. Each skill has:

```
skills/<skill-name>/
├── SKILL.md            Entry point — description, triggers, key patterns, references
├── references/         Supporting guides, checklists, patterns (markdown)
└── scripts/            Automation scripts (.sh for Linux/macOS, .ps1 for Windows)
```

**How they activate:** Skills are loaded when you mention trigger keywords in your prompt. For example, asking about "JPA N+1" triggers `spring-jpa-patterns`, and asking about "Docker multi-stage build" triggers `docker-containers`.

**Skill categories:**

| Category | Skills | Examples |
|----------|--------|---------|
| Java Core | 10 | `java-oop-design`, `java-design-patterns`, `java-concurrency`, `java-modern-features`, `java-type-design`, `java-generics`, `java-functional`, `java-exception-handling`, `java-secure-coding`, `java-modernization` |
| Spring | 10 | `spring-boot-core`, `spring-boot-rest`, `spring-boot-security`, `spring-boot-testing`, `spring-jpa-patterns`, `spring-data-access`, `spring-cache-retry`, `spring-graphql`, `spring-actuator-monitoring`, `spring-cloud` |
| Testing | 2 | `java-testing`, `tdd-workflow` |
| Architecture | 3 | `architecture-design`, `ddd-patterns`, `saga-patterns` |
| Data | 1 | `database-design` |
| API | 1 | `api-design` |
| DevOps | 3 | `maven-build`, `docker-containers`, `bash-scripting` |
| Git/GitHub | 6 | `git-workflow`, `git-commit`, `git-hooks`, `github-pr-review`, `github-automation`, `changelog-release` |
| Documentation/Review | 5 | `java-documentation`, `java-code-review`, `code-reviewer`, `code-refactoring`, `dependency-audit` |
| Other | 5 | `error-debugging`, `java-observability`, `java-performance`, `agile-workflow`, `project-planning` |

See [docs/skills-reference.md](.cursor/docs/skills-reference.md) for the complete catalog.

---

## How Agents Work

Agents are persona definitions in `agents/<name>.md`. Each agent combines an identity, scope, and curated set of rules and skills into a focused workflow.

| Agent | Focus |
|-------|-------|
| `java-coder` | Java 17/21 implementation — features, refactoring, modern patterns |
| `java-reviewer` | Code review — standards, design, security, performance |
| `spring-boot-engineer` | Spring Boot 4.x — APIs, services, persistence, security, tests |
| `test-quality-guardian` | Test quality — coverage, anti-patterns, test strategy |
| `architect-reviewer` | Architecture review — ADRs, patterns, system design |
| `security-auditor` | Security audit — OWASP, Spring Security, JWT, dependencies |
| `database-advisor` | Database — schema, queries, migrations, Redis, JPA |
| `build-release-helper` | Build/release — Maven, dependencies, quality gates, changelog |
| `modernization-advisor` | Upgrades — Java 8→17→21, Spring Boot migration, OpenRewrite |
| `docker-expert` | Containers — Dockerfiles, Compose, Java image optimization |
| `git-assistant` | Git operations — branching, rebasing, conflicts, recovery |
| `github-reviewer` | PR lifecycle — creation, review, feedback, GitHub workflow |
| `release-helper` | Releases — versioning, changelog, tags, publishing |

See [docs/agents-reference.md](.cursor/docs/agents-reference.md) for the complete catalog.

---

## Templates

Reusable templates in `templates/` for common project artifacts:

| Template | Purpose |
|----------|---------|
| `pull-request-template-java.md` | Java/Spring PR with quality and Java-specific checklists |
| `pull-request-template.md` | Generic PR with summary, testing, and self-review |
| `bug-report-template-java.md` | Java/Spring bug report with environment and logs |
| `feature-request-template-java.md` | Feature request with API design and acceptance criteria |
| `issue-template-bug.md` | Generic bug report |
| `issue-template-feature.md` | Generic feature request |
| `architecture-review-template.md` | Architecture review with decisions table and checklist |
| `adr-template.md` | Architecture Decision Record (MADR format) |
| `api-review-template.md` | API design review with resource and security checklists |

---

## Shared Resources

Cross-cutting standards in `shared/`:

| File | Purpose |
|------|---------|
| `java-conventions.md` | Java baseline (17/21), naming, packages, types, imports, Jackson, MapStruct conventions |
| `supported-version-matrix.md` | Version matrix for Java, Spring, Jakarta, JUnit, tooling (updated 2026-04-22) |
| `quality-gates.md` | Merge and release gates — build, coverage, static analysis, security |
| `toolchain-standards.md` | JDK, Maven/Gradle, IDEs, formatting, CI, containers, persistence, monitoring tools |
| `glossary.md` | Definitions for Java, Spring, Git, testing, and architecture terms |
| `conventions.md` | `.cursor/` directory layout and naming rules |
| `reusable-prompts.md` | Reusable prompt fragments for agents and skills |

---

## Scripts

Helper scripts live in `skills/<name>/scripts/`. Every bash script (`.sh`) has a matching PowerShell equivalent (`.ps1`).

**Running on Linux / macOS:**

```bash
cd your-project-root
bash .cursor/skills/java-testing/scripts/run-tests.sh [module]
bash .cursor/skills/maven-build/scripts/validate-build.sh
```

**Running on Windows (PowerShell):**

```powershell
cd your-project-root
powershell -File .cursor\skills\java-testing\scripts\run-tests.ps1 -Module "api"
powershell -File .cursor\skills\maven-build\scripts\validate-build.ps1
```

**Available scripts (15 pairs):**

| Skill | Script | Purpose |
|-------|--------|---------|
| `maven-build` | `validate-build` | Validate and compile a Maven project |
| `maven-build` | `dependency-audit` | Audit dependency tree, updates, unused, duplicates |
| `java-code-review` | `run-checkstyle` | Run Checkstyle static analysis |
| `java-code-review` | `run-spotbugs` | Run SpotBugs bug detection |
| `java-testing` | `run-tests` | Run test suite with JaCoCo coverage |
| `java-testing` | `coverage-report` | Generate and summarize JaCoCo report |
| `java-performance` | `run-profiler` | Start JFR profiling (attach or launch) |
| `github-pr-review` | `pr-description-generator` | Generate structured PR description from diff |
| `git-hooks` | `install-hooks` | Install pre-commit, commit-msg, pre-push, post-merge hooks |
| `changelog-release` | `generate-changelog` | Generate changelog from conventional commits |
| `github-automation` | `setup-branch-protection` | Configure GitHub branch protection via `gh` CLI |
| `git-commit` | `smart-commit` | Validated conventional commit with branch safety |
| `git-workflow` | `validate-branch-name` | Validate branch name against conventions |
| `git-workflow` | `check-commit-message` | Validate commit message format |
| `git-workflow` | `clean-merged-branches` | Delete local and remote merged branches |

---

## Customizing

### Adding a New Rule

1. Create `rules/<category>/<name>.mdc` with frontmatter:

```yaml
---
description: What this rule enforces
globs: ["**/*.java"]
alwaysApply: false
---
```

2. Write the rule body in Markdown below the frontmatter.

### Adding a New Skill

1. Create `skills/<name>/SKILL.md` with metadata block and content.
2. Add reference files in `skills/<name>/references/`.
3. Add scripts in `skills/<name>/scripts/` (both `.sh` and `.ps1`).

### Adding a New Agent

1. Create `agents/<name>.md` with identity, scope, workflow, and related rules/skills sections.

---

## Version Alignment

All content is aligned with:

- **Java 17** (LTS) and **Java 21** (LTS) as primary baselines
- **Spring Boot 4.0.x** / **Spring Framework 7.0.x**
- **Jakarta EE 11** (`jakarta.*` namespace)
- **JUnit 5.11.x** (with forward-looking JUnit 6 notes)
- **Maven 3.9.x** and **Gradle 8.x** (Kotlin DSL)

See `shared/supported-version-matrix.md` for the full version table.

---

## Further Reading

- [Rules Reference](.cursor/docs/rules-reference.md) — complete catalog of all 64 rules
- [Skills Reference](.cursor/docs/skills-reference.md) — complete catalog of all 46 skills
- [Agents Reference](.cursor/docs/agents-reference.md) — complete catalog of all 13 agents
- [Prompt Examples](.cursor/docs/prompt-examples.md) — copy-paste-ready prompts with `@` reference examples
