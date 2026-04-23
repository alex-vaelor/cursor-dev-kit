---
name: jpa-patterns
description: JPA/Hibernate patterns and common pitfalls (N+1, lazy loading, transactions, queries). Use when user has JPA performance issues, LazyInitializationException, or asks about entity relationships and fetching strategies.
---

# JPA Patterns Skill

Best practices and common pitfalls for JPA/Hibernate in Spring applications.

## When to Use
- User mentions "N+1 problem" / "too many queries"
- LazyInitializationException errors
- Questions about fetch strategies (EAGER vs LAZY)
- Transaction management issues
- Entity relationship design
- Query optimization

---

## Quick Reference: Common Problems

| Problem | Symptom | Solution |
|---------|---------|----------|
| N+1 queries | Many SELECT statements | JOIN FETCH, @EntityGraph |
| LazyInitializationException | Error outside transaction | Open Session in View, DTO projection, JOIN FETCH |
| Slow queries | Performance issues | Pagination, projections, indexes |
| Dirty checking overhead | Slow updates | Read-only transactions, DTOs |
| Lost updates | Concurrent modifications | Optimistic locking (@Version) |

---

## N+1 Problem

> The #1 JPA performance killer

### The Problem

```java
// ❌ BAD: N+1 queries
@Entity
public class Author {
    @Id private Long id;
    private String name;

    @OneToMany(mappedBy = "author", fetch = FetchType.LAZY)
    private List<Book> books;
}

// This innocent code...
List<Author> authors = authorRepository.findAll();  // 1 query
for (Author author : authors) {
    System.out.println(author.getBooks().size());   // N queries!
}
// Result: 1 + N queries (if 100 authors = 101 queries)
```

### Solution 1: JOIN FETCH (JPQL)

```java
// ✅ GOOD: Single query with JOIN FETCH
public interface AuthorRepository extends JpaRepository<Author, Long> {

    @Query("SELECT a FROM Author a JOIN FETCH a.books")
    List<Author> findAllWithBooks();
}

// Usage - single query
List<Author> authors = authorRepository.findAllWithBooks();
```

### Solution 2: @EntityGraph

```java
// ✅ GOOD: EntityGraph for declarative fetching
public interface AuthorRepository extends JpaRepository<Author, Long> {

    @EntityGraph(attributePaths = {"books"})
    List<Author> findAll();

    // Or with named graph
    @EntityGraph(value = "Author.withBooks")
    List<Author> findAllWithBooks();
}

// Define named graph on entity
@Entity
@NamedEntityGraph(
    name = "Author.withBooks",
    attributeNodes = @NamedAttributeNode("books")
)
public class Author {
    // ...
}
```

### Solution 3: Batch Fetching

```java
// ✅ GOOD: Batch fetching (Hibernate-specific)
@Entity
public class Author {

    @OneToMany(mappedBy = "author")
    @BatchSize(size = 25)  // Fetch 25 at a time
    private List<Book> books;
}

// Or globally in application.properties
spring.jpa.properties.hibernate.default_batch_fetch_size=25
```

### Detecting N+1

```yaml
# Enable SQL logging to detect N+1
spring:
  jpa:
    show-sql: true
    properties:
      hibernate:
        format_sql: true

logging:
  level:
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
```

---

## Lazy Loading

### FetchType Basics

```java
@Entity
public class Order {

    // LAZY: Load only when accessed (default for collections)
    @OneToMany(mappedBy = "order", fetch = FetchType.LAZY)
    private List<OrderItem> items;

    // EAGER: Always load immediately (default for @ManyToOne, @OneToOne)
    @ManyToOne(fetch = FetchType.EAGER)  // ⚠️ Usually bad
    private Customer customer;
}
```

### Best Practice: Default to LAZY

```java
// ✅ GOOD: Always use LAZY, fetch when needed
@Entity
public class Order {

    @ManyToOne(fetch = FetchType.LAZY)  // Override EAGER default
    private Customer customer;

    @OneToMany(mappedBy = "order", fetch = FetchType.LAZY)
    private List<OrderItem> items;
}
```

### LazyInitializationException

```java
// ❌ BAD: Accessing lazy field outside transaction
@Service
public class OrderService {

    public Order getOrder(Long id) {
        return orderRepository.findById(id).orElseThrow();
    }
}

// In controller (no transaction)
Order order = orderService.getOrder(1L);
order.getItems().size();  // 💥 LazyInitializationException!
```

### Solutions for LazyInitializationException

**Solution 1: JOIN FETCH in query**
```java
// ✅ Fetch needed associations in query
@Query("SELECT o FROM Order o JOIN FETCH o.items WHERE o.id = :id")
Optional<Order> findByIdWithItems(@Param("id") Long id);
```

**Solution 2: @Transactional on service method**
```java
// ✅ Keep transaction open while accessing
@Service
public class OrderService {

    @Transactional(readOnly = true)
    public OrderDTO getOrderWithItems(Long id) {
        Order order = orderRepository.findById(id).orElseThrow();
        // Access within transaction -- lazy collection is loaded here
        return new OrderDTO(order.getId(), order.getDescription(), order.getItems().size());
    }
}
```

**Solution 3: DTO Projection (Recommended)**
```java
// ✅ BEST: Fetch only what you need -- no lazy loading at all
public interface OrderRepository extends JpaRepository<Order, Long> {

    @Query("""
        SELECT new com.example.dto.OrderSummary(o.id, o.description, SIZE(o.items))
        FROM Order o WHERE o.id = :id
        """)
    Optional<OrderSummary> findSummaryById(@Param("id") Long id);
}

public record OrderSummary(Long id, String description, int itemCount) {}
```
DTO projections avoid lazy loading entirely because no managed entity is returned.

---

## Open Session in View (OSIV)

### What It Does
`spring.jpa.open-in-view=true` (the default) keeps the Hibernate Session open through the entire HTTP request, allowing lazy loading in controllers and view templates.

### Why to Avoid in Production
- **N+1 in views**: Lazy collections accessed in serialization trigger queries outside service layer
- **Long-held database connections**: Session stays open for the full request, including response rendering
- **Hidden data access**: Queries fire in unexpected places, making performance unpredictable
- **Tight coupling**: Controllers depend on entity state, not explicit DTOs

### Disable
```yaml
spring:
  jpa:
    open-in-view: false
```
Spring Boot logs a warning if OSIV is enabled. Always disable and use JOIN FETCH or DTO projections.

---

## Dirty Checking Optimization

### The Mechanism
Hibernate tracks changes to managed entities and auto-generates UPDATE statements at flush time. This means every loaded entity is compared field-by-field against a snapshot.

### Optimization: Read-Only Transactions
```java
@Transactional(readOnly = true)
public List<OrderSummary> findAllOrders() {
    // Hibernate skips dirty checking for read-only transactions
    return orderRepository.findAllSummaries();
}
```

### Optimization: Detached Entities
```java
@Transactional(readOnly = true)
public Order findOrder(Long id) {
    Order order = orderRepository.findById(id).orElseThrow();
    entityManager.detach(order); // no dirty checking on this entity
    return order;
}
```

### Optimization: StatelessSession for Bulk Reads
```java
// For very large read-only datasets
Session session = entityManager.unwrap(Session.class);
try (var stateless = session.getSessionFactory().openStatelessSession()) {
    try (var scroll = stateless.createQuery("FROM Order o WHERE o.status = :s", Order.class)
            .setParameter("s", OrderStatus.PENDING)
            .scroll(ScrollMode.FORWARD_ONLY)) {
        while (scroll.next()) {
            process(scroll.get());
        }
    }
}
```

---

## Optimistic Locking

### Setup
```java
@Entity
public class Order {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Version
    private Long version; // Hibernate increments on each UPDATE
}
```

### Handling Conflicts
```java
@Service
public class OrderService {

    @Retryable(retryFor = OptimisticLockException.class, maxAttempts = 3,
               backoff = @Backoff(delay = 100))
    @Transactional
    public Order updateOrder(Long id, UpdateOrderRequest request) {
        var order = orderRepository.findById(id)
            .orElseThrow(() -> new OrderNotFoundException(id));
        order.setDescription(request.description());
        return orderRepository.save(order);
    }

    @Recover
    public Order recoverUpdate(OptimisticLockException ex, Long id, UpdateOrderRequest request) {
        throw new ConflictException("Order was modified by another user. Please retry.");
    }
}
```

---

## Pagination Pitfalls

### Page vs Slice
| Type | COUNT Query | Use When |
|------|-------------|----------|
| `Page<T>` | Yes (extra query) | Need total count (UI pagination with page numbers) |
| `Slice<T>` | No | Infinite scroll, "load more" (better performance) |

### COUNT Query Performance
```java
// The generated COUNT can be slow on large tables
Page<Order> findByStatus(OrderStatus status, Pageable pageable);

// Override with optimized COUNT
@Query(value = "SELECT o FROM Order o WHERE o.status = :status",
       countQuery = "SELECT COUNT(o.id) FROM Order o WHERE o.status = :status")
Page<Order> findByStatus(@Param("status") OrderStatus status, Pageable pageable);
```

### Keyset Pagination (Cursor-Based)
```java
// Better for large datasets -- no OFFSET performance degradation
@Query("SELECT o FROM Order o WHERE o.id > :lastId ORDER BY o.id ASC")
Slice<Order> findNextPage(@Param("lastId") Long lastId, Pageable pageable);
```

### JOIN FETCH + Pagination Warning
```java
// ⚠️ JOIN FETCH + Pageable triggers in-memory pagination (HHH000104 warning)
@Query("SELECT o FROM Order o JOIN FETCH o.items")
Page<Order> findAllWithItems(Pageable pageable); // BAD: fetches ALL then paginates in memory

// ✅ Fix: two-query approach
@Query("SELECT o.id FROM Order o WHERE o.status = :status")
Page<Long> findIdsByStatus(@Param("status") OrderStatus status, Pageable pageable);

@Query("SELECT o FROM Order o JOIN FETCH o.items WHERE o.id IN :ids")
List<Order> findByIdsWithItems(@Param("ids") List<Long> ids);
```

---

## Flush Modes

| Mode | Behavior | Use Case |
|------|----------|----------|
| `AUTO` (default) | Flush before queries that might be affected | Standard operations |
| `COMMIT` | Flush only at commit time | Performance: skip pre-query flushes when you know queries won't read dirty data |
| `MANUAL` | Never auto-flush; caller must flush explicitly | Batch processing, read-only operations |

```java
@Transactional
public void batchProcess() {
    entityManager.setFlushMode(FlushModeType.COMMIT);
    for (int i = 0; i < items.size(); i++) {
        entityManager.persist(items.get(i));
        if (i % 50 == 0) {
            entityManager.flush();
            entityManager.clear(); // free memory
        }
    }
}
```

---

## EntityManager Lifecycle

### persist vs merge
| Method | Input | Effect | Returns |
|--------|-------|--------|---------|
| `persist(entity)` | New (transient) | Makes managed; INSERT at flush | void (entity is now managed) |
| `merge(entity)` | Detached or new | Copies state into managed copy; INSERT or UPDATE | Managed copy (different instance) |

```java
// persist: for new entities
var order = new Order();
order.setDescription("New");
entityManager.persist(order); // order is now managed

// merge: for detached entities
Order detached = orderService.findOrder(1L); // returned from read-only transaction
detached.setDescription("Updated");
Order managed = entityManager.merge(detached); // managed != detached
```

### detach, clear, flush
| Method | Effect |
|--------|--------|
| `detach(entity)` | Remove single entity from persistence context; changes are lost |
| `clear()` | Detach all entities; useful in batch loops to free memory |
| `flush()` | Synchronize persistence context to DB (execute pending SQL) without committing |

---

## Common Hibernate Exceptions

| Exception | Cause | Fix |
|-----------|-------|-----|
| `LazyInitializationException` | Accessing lazy field outside transaction | JOIN FETCH, `@EntityGraph`, DTO projection, or `@Transactional` |
| `OptimisticLockException` | Concurrent modification detected via `@Version` | Retry or notify user |
| `StaleObjectStateException` | Hibernate-specific: row was updated/deleted by another transaction | Same as optimistic lock |
| `NonUniqueObjectException` | Two instances of the same entity (same ID) in one session | Use `merge()` instead of `persist()`; don't mix managed and detached |
| `PersistentObjectException` | Calling `persist()` on a detached entity | Use `merge()` for detached entities |
| `TransientObjectException` | Persisting entity that references a transient (unsaved) entity | Persist the referenced entity first, or add `CascadeType.PERSIST` |
| `DataIntegrityViolationException` | Unique constraint, FK constraint, NOT NULL violation | Validate before save; handle with `@ExceptionHandler` |
