---
name: java-concurrency
description: "Use when applying Java concurrency best practices -- including virtual threads, thread safety, ExecutorService management, CompletableFuture, immutability, deadlock avoidance, ScopedValue, backpressure, cancellation discipline, and concurrent system observability."
risk: critical
source: consolidated
version: "1.0.0"
license: Apache-2.0
metadata:
  category: quality
  triggers: concurrency, thread, virtual thread, CompletableFuture, ExecutorService, synchronized, lock, deadlock, parallel, async
  role: specialist
  scope: java-concurrency
  original-author: Juan Antonio Breña Moral
  related-skills: java-performance, java-observability
---

# Java Concurrency

Identify and apply Java concurrency best practices for thread safety, scalability, and maintainability using modern `java.util.concurrent` utilities and virtual threads.

## When to Use This Skill

- Review Java code for concurrency correctness
- Implement virtual thread patterns (Java 21+)
- Design thread-safe data structures and services
- Apply CompletableFuture for async workflows
- Resolve deadlock, race condition, or pinning issues
- Implement backpressure and overload protection

## Coverage

- Thread safety fundamentals: `ConcurrentHashMap`, `AtomicInteger`, `ReentrantLock`, Java Memory Model
- `ExecutorService` thread pool configuration: sizing, queues, rejection policies, graceful shutdown
- Producer-Consumer and Publish-Subscribe patterns with `BlockingQueue`
- `CompletableFuture` for non-blocking async composition
- Immutability and safe publication (`volatile`, static initializers)
- Virtual threads (`Executors.newVirtualThreadPerTaskExecutor()`) for I/O-bound scalability
- `ScopedValue` over `ThreadLocal` for immutable cross-task data
- Cooperative cancellation and `InterruptedException` discipline
- Backpressure with bounded queues and `CallerRunsPolicy`
- Deadlock avoidance via global lock ordering and `tryLock` with timeouts
- ForkJoin/parallel-stream discipline for CPU-bound work
- Virtual-thread pinning detection (JFR `VirtualThreadPinned`)
- Fit-for-purpose primitives: `LongAdder`, `StampedLock`, `Semaphore`, `Phaser`

## Constraints

- **MANDATORY**: Run `./mvnw compile` or `mvn compile` before applying any change
- **SAFETY**: If compilation fails, stop immediately -- compilation failure is a blocking condition
- **VERIFY**: Run `./mvnw clean verify` or `mvn clean verify` after applying improvements
- **BEFORE APPLYING**: Read the reference for detailed examples and constraints

## References

| Topic | File | When to Load |
|-------|------|--------------|
| Full concurrency guidelines | `references/concurrency-guidelines.md` | Before any concurrency review |

## Related Rules

- `rules/java/concurrency.mdc` -- concurrency rules
