---
name: java-performance
description: "Use when profiling, optimizing, or load-testing Java applications -- including JMeter performance testing, JFR/async-profiler-based profiling (detect, analyze, refactor, verify), hotspot identification, memory analysis, and performance regression prevention."
risk: safe
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: performance, profiling, JMeter, JFR, memory, CPU, hotspot, benchmark, load test, throughput, latency, GC
  role: specialist
  scope: java-performance
  original-author: Juan Antonio Breña Moral
  related-skills: java-concurrency, java-observability
---

# Java Performance

Profile and optimize Java applications using systematic performance analysis and testing workflows.

## When to Use This Skill

- Run load and performance tests with JMeter
- Profile Java applications with JFR or async-profiler
- Detect performance hotspots and memory issues
- Analyze profiling results and identify root causes
- Refactor for performance improvements
- Verify performance improvements with before/after measurements

## Coverage

### Performance Testing
- JMeter test plans for throughput and latency measurement
- Load profiles: baseline, stress, soak, spike
- Performance metrics collection and analysis

### Profiling Pipeline (Detect -> Analyze -> Refactor -> Verify)
1. **Detect**: Identify hotspots using JFR, async-profiler, thread dumps
2. **Analyze**: Interpret flame graphs, allocation profiles, lock contention reports
3. **Refactor**: Apply targeted optimizations based on evidence
4. **Verify**: Confirm improvements with before/after benchmarks

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **EVIDENCE-BASED**: Never optimize without profiling evidence; avoid premature optimization
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements

## References

| Topic | File | When to Load |
|-------|------|--------------|
| JMeter performance testing | `references/jmeter-guidelines.md` | When setting up load tests |
| Profiling: detect hotspots | `references/profiling-detect.md` | When starting profiling |
| Profiling: analyze results | `references/profiling-analyze.md` | When interpreting profiling data |
| Profiling: refactor for performance | `references/profiling-refactor.md` | When applying optimizations |
| Profiling: verify improvements | `references/profiling-verify.md` | When confirming improvements |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/run-profiler.sh` | Start JFR profiling on a running JVM |

## Related Rules

- `rules/java/concurrency.mdc` -- concurrency performance patterns
