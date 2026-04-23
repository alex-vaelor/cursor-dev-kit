---
name: bash-scripting
description: "Use when writing or reviewing shell scripts -- including strict mode, error handling, argument parsing, logging, defensive patterns, ShellCheck validation, and Bats testing."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: tooling
  triggers: bash, shell script, sh, automation script, deployment script, CI script, ShellCheck
  role: specialist
  scope: bash
  related-skills: docker-containers
---

# Bash Scripting

Write production-ready shell scripts with defensive patterns, structured error handling, and testing.

## When to Use This Skill

- Write automation, deployment, or CI/CD scripts
- Review shell scripts for safety and correctness
- Add error handling and logging to existing scripts
- Set up ShellCheck linting and Bats testing
- Create helper scripts for build and release workflows

## Script Template

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

log()   { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }
error() { log "ERROR: $*" >&2; exit 1; }

usage() { cat <<EOF
Usage: ${SCRIPT_NAME} [OPTIONS] <args>
Options:
  -h, --help      Show this help
  -v, --verbose   Enable verbose output
EOF
}

cleanup() { rm -f "${TMPFILE:-}"; }
trap cleanup EXIT

main() {
    log "Started"
    # Implementation
    log "Completed"
}

main "$@"
```

## Key Practices

- Always `set -euo pipefail` (strict mode)
- Quote all variable expansions: `"${var}"`
- Use `readonly` for constants, `local` for function variables
- `trap cleanup EXIT` for guaranteed cleanup
- Validate inputs: check arg count, file existence, command availability
- Log to stderr for errors, stdout for normal output

## Quality Gates

- ShellCheck passes with zero warnings
- Bats tests for critical paths
- Error handling verified (edge cases, missing inputs)
- Documentation: script header, usage function, inline comments for non-obvious logic

## Constraints

- Run `shellcheck script.sh` before committing
- All scripts must have `#!/usr/bin/env bash` shebang
- All scripts must use strict mode (`set -euo pipefail`)

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Bash patterns and examples | `references/bash-patterns.md` | When writing or reviewing scripts |

## Related Rules

- `rules/bash/scripting.mdc` -- bash scripting conventions
