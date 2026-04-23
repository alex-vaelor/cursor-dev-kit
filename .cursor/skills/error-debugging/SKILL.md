---
name: error-debugging
description: "Use when debugging errors in Java applications -- including systematic debugging strategies, stack trace analysis, thread dump analysis, memory analysis, production incident investigation, and error pattern diagnosis."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Shell
metadata:
  category: quality
  triggers: debug, error, exception, stack trace, thread dump, memory leak, OutOfMemoryError, deadlock, production incident, NullPointerException
  role: specialist
  scope: debugging
  related-skills: java-observability, java-performance, java-testing
---

# Error Debugging

Systematically debug Java application errors using structured analysis and proven strategies.

## When to Use This Skill

- Investigate exceptions and stack traces
- Debug production incidents
- Analyze thread dumps for deadlocks and contention
- Diagnose memory leaks and `OutOfMemoryError`
- Track down intermittent / flaky failures
- Analyze performance regressions

## Debugging Workflow

1. **Reproduce**: Capture the exact error, stack trace, and environment
2. **Hypothesize**: Form 2-3 hypotheses about the root cause
3. **Narrow**: Use binary search, targeted logging, or breakpoints to isolate
4. **Verify**: Confirm the root cause with a minimal reproducing test
5. **Fix**: Apply the fix and verify all tests pass
6. **Document**: Record the root cause and fix for future reference

## Common Java Error Patterns

| Error | Likely Cause | First Step |
|-------|-------------|------------|
| `NullPointerException` | Uninitialized reference, missing Optional | Check the stack trace line; add null check or Optional |
| `ClassCastException` | Incorrect type assumption | Check generic erasure, verify actual runtime type |
| `ConcurrentModificationException` | Collection modified during iteration | Use `CopyOnWriteArrayList`, iterator's `remove()`, or stream |
| `OutOfMemoryError: Heap` | Memory leak, large object graphs | Heap dump analysis with Eclipse MAT or VisualVM |
| `OutOfMemoryError: Metaspace` | Class loader leak, too many classes | Check for classloader leaks, increase Metaspace |
| `StackOverflowError` | Infinite recursion | Check recursive method base cases |
| `LazyInitializationException` | JPA entity accessed outside transaction | Use `JOIN FETCH` or `@Transactional` |
| `DeadlockException` | Circular lock acquisition | Thread dump analysis, lock ordering |

## Thread Dump Analysis

```bash
jcmd <pid> Thread.print > thread-dump.txt
# Or: kill -3 <pid> (sends to stderr)
```

Look for:
- `BLOCKED` threads waiting on the same monitor
- Circular `waiting to lock` patterns (deadlock)
- Many threads in `WAITING` state (thread pool exhaustion)

## Heap Dump Analysis

```bash
jcmd <pid> GC.heap_dump /tmp/heap.hprof
# Or: -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/
```

Analyze with Eclipse MAT: look for dominator tree, leak suspects, histogram.

## Constraints

- Always reproduce the issue with a test before fixing
- Do not fix symptoms; find root cause
- Preserve error context (stack traces, logs) for documentation

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Debugging strategies playbook | `references/debugging-strategies.md` | When starting systematic debugging |
| Error pattern catalog | `references/error-patterns.md` | When diagnosing specific error types |
| Incident response guide | `references/incident-response-guide.md` | When handling production incidents |

## Related Rules

- `rules/java/exception-handling.mdc` -- exception handling
- `rules/java/logging.mdc` -- logging for diagnosis

## Related Skills

- `skills/java-observability/` -- logging and monitoring
- `skills/java-performance/` -- profiling and analysis
