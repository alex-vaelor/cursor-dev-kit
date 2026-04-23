# Java Error Pattern Catalog

## NullPointerException

**Symptoms**: `java.lang.NullPointerException` at specific line
**Root Causes**:
- Uninitialized fields, missing dependency injection
- Optional not used for nullable returns
- Collection methods returning null instead of empty
**Fix Strategy**: Check the exact line in stack trace; add `Objects.requireNonNull` at boundaries, use Optional, check DI configuration

## ClassCastException

**Symptoms**: `java.lang.ClassCastException: X cannot be cast to Y`
**Root Causes**:
- Generic type erasure -- collection contains unexpected types
- Incorrect deserialization configuration
- Polymorphic dispatch without proper type checks
**Fix Strategy**: Use `instanceof` pattern matching before casting; check generic type parameters

## ConcurrentModificationException

**Symptoms**: Exception during iteration over collection
**Root Causes**:
- Modifying a collection during for-each iteration
- Multiple threads accessing shared mutable collections
**Fix Strategy**: Use `Iterator.remove()`, `CopyOnWriteArrayList`, or collect modifications and apply after iteration

## OutOfMemoryError: Java heap space

**Symptoms**: JVM crashes with OOM, progressively slower GC
**Root Causes**:
- Memory leak (objects retained longer than needed)
- Large result sets loaded into memory
- Unbounded caches or collections
**Fix Strategy**: Heap dump analysis with Eclipse MAT; look for dominator tree, retained size, classloader leaks

## OutOfMemoryError: Metaspace

**Symptoms**: OOM in Metaspace area
**Root Causes**:
- Classloader leak (common in web containers, hot deployment)
- Excessive dynamic proxy/bytecode generation
**Fix Strategy**: Increase Metaspace (`-XX:MaxMetaspaceSize`); check for classloader leaks

## StackOverflowError

**Symptoms**: Deep stack trace, recursive method calls
**Root Causes**:
- Missing or incorrect recursion base case
- Circular `toString()`, `equals()`, `hashCode()` in entity relationships
**Fix Strategy**: Add base case; check `@ToString(exclude=...)` on Lombok entities

## LazyInitializationException (JPA)

**Symptoms**: `org.hibernate.LazyInitializationException: could not initialize proxy`
**Root Causes**:
- Accessing lazy-loaded association outside transaction boundary
- Missing `@Transactional` on service method
**Fix Strategy**: Use `JOIN FETCH`, `@EntityGraph`, or ensure access within `@Transactional` scope

## DeadlockException / Thread Blocked

**Symptoms**: Application hangs, threads in BLOCKED state
**Root Causes**:
- Circular lock acquisition between threads
- Synchronized methods calling each other across objects
- Database deadlocks from conflicting row-level locks
**Fix Strategy**: Thread dump analysis; establish consistent lock ordering; use `tryLock` with timeout

## Connection Pool Exhaustion

**Symptoms**: `Unable to acquire connection from pool`, application hangs
**Root Causes**:
- Long-running transactions holding connections
- Connection leak (connection not returned to pool)
- Pool size too small for concurrent load
**Fix Strategy**: Check for missing `@Transactional`, leaked connections; configure leak detection (`spring.datasource.hikari.leak-detection-threshold`)

## Spring Context Startup Failure

**Symptoms**: `ApplicationContextException`, `BeanCreationException`
**Root Causes**:
- Missing bean dependency
- Circular dependency between beans
- Incorrect `@Conditional` configuration
**Fix Strategy**: Read full stack trace for the root cause bean; check `@Qualifier`, constructor parameters; break circular dependencies with `@Lazy`
