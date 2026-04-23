# Hibernate Performance

## Second-Level Cache (L2)

### How It Works
- **L1 cache**: Per-session (persistence context). Automatic. Cleared when session closes.
- **L2 cache**: Shared across sessions. Must be explicitly enabled. Stores entity state by ID.
- **Query cache**: Caches query result IDs. Combined with L2 cache for full result caching.

```
Session 1 → L1 Cache → L2 Cache (shared) → Database
Session 2 → L1 Cache ↗
```

### When to Use L2 Cache
| Use L2 Cache | Skip L2 Cache |
|-------------|--------------|
| Reference data (countries, currencies, categories) | Frequently updated entities |
| Read-heavy, rarely changing entities | Entities modified by multiple services |
| Small result sets accessed by many sessions | Large entities (better to use DTO projections) |

### Setup with Caffeine
```xml
<dependency>
  <groupId>org.hibernate.orm</groupId>
  <artifactId>hibernate-jcache</artifactId>
</dependency>
<dependency>
  <groupId>com.github.ben-manes.caffeine</groupId>
  <artifactId>caffeine</artifactId>
</dependency>
<dependency>
  <groupId>com.github.ben-manes.caffeine</groupId>
  <artifactId>jcache</artifactId>
</dependency>
```

```yaml
spring:
  jpa:
    properties:
      hibernate:
        cache:
          use_second_level_cache: true
          use_query_cache: true
          region:
            factory_class: org.hibernate.cache.jcache.internal.JCacheRegionFactory
      jakarta:
        persistence:
          sharedCache:
            mode: ENABLE_SELECTIVE
```

### Entity Caching
```java
@Entity
@Table(name = "countries")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class Country {
    @Id private String code;
    private String name;
}

@Entity
@Table(name = "products")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Product {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private BigDecimal price;

    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany(mappedBy = "product")
    private List<ProductVariant> variants;
}
```

### Cache Concurrency Strategies
| Strategy | Reads | Writes | Isolation | Use Case |
|----------|-------|--------|-----------|----------|
| `READ_ONLY` | Fast | Not supported | N/A | Immutable reference data |
| `NONSTRICT_READ_WRITE` | Fast | Eventual consistency | Weak | Rarely updated, stale OK briefly |
| `READ_WRITE` | Fast | Consistent | Strong | Read-heavy, occasionally updated |
| `TRANSACTIONAL` | Fast | JTA required | Full | JTA environments (rare) |

### Query Cache
```java
public interface CountryRepository extends JpaRepository<Country, String> {
    @QueryHints(@QueryHint(name = "org.hibernate.cacheable", value = "true"))
    List<Country> findAll();
}
```
Query cache stores the IDs returned by a query. Each ID then resolves from L2 cache. Invalidated when any entity of the queried type is modified.

### Cache Eviction
```java
@Service
public class CacheService {
    @PersistenceContext
    private EntityManager entityManager;

    public void evictEntity(Class<?> entityClass, Object id) {
        entityManager.getEntityManagerFactory().getCache().evict(entityClass, id);
    }

    public void evictAll(Class<?> entityClass) {
        entityManager.getEntityManagerFactory().getCache().evict(entityClass);
    }
}
```

---

## Batch Processing

### Hibernate Batch Insert/Update
```yaml
spring:
  jpa:
    properties:
      hibernate:
        jdbc:
          batch_size: 50
        order_inserts: true
        order_updates: true
```
- `batch_size`: Number of statements grouped in a single JDBC batch
- `order_inserts`/`order_updates`: Groups statements by entity type for efficient batching
- `GenerationType.IDENTITY` disables batch inserts (use `SEQUENCE` instead)

### Batch Processing Pattern
```java
@Transactional
public void importOrders(List<CreateOrderRequest> requests) {
    for (int i = 0; i < requests.size(); i++) {
        var order = mapper.toEntity(requests.get(i));
        entityManager.persist(order);
        if (i > 0 && i % 50 == 0) {
            entityManager.flush();
            entityManager.clear();
        }
    }
}
```

### Bulk Operations with @Modifying
```java
// Bypass persistence context -- direct SQL
@Modifying(clearAutomatically = true, flushAutomatically = true)
@Query("UPDATE Order o SET o.status = :status WHERE o.createdAt < :before")
int archiveOldOrders(@Param("status") OrderStatus status, @Param("before") Instant before);
```
Use `clearAutomatically = true` to evict stale entities after bulk updates.

### StatelessSession for Large Batch Reads
```java
public void exportAllOrders(Consumer<Order> processor) {
    Session session = entityManager.unwrap(Session.class);
    try (var stateless = session.getSessionFactory().openStatelessSession()) {
        try (var scroll = stateless.createQuery("FROM Order", Order.class)
                .setFetchSize(100)
                .scroll(ScrollMode.FORWARD_ONLY)) {
            while (scroll.next()) {
                processor.accept(scroll.get());
            }
        }
    }
}
```
`StatelessSession` has no persistence context, no dirty checking, no caching -- minimal memory footprint.

---

## Query Hints

```java
public interface OrderRepository extends JpaRepository<Order, Long> {

    @QueryHints({
        @QueryHint(name = "org.hibernate.readOnly", value = "true"),
        @QueryHint(name = "org.hibernate.fetchSize", value = "50"),
        @QueryHint(name = "org.hibernate.comment", value = "Dashboard: active orders query")
    })
    @Query("SELECT o FROM Order o WHERE o.status = :status")
    List<Order> findActiveOrders(@Param("status") OrderStatus status);

    @QueryHints(@QueryHint(name = "jakarta.persistence.query.timeout", value = "5000"))
    @Query("SELECT o FROM Order o JOIN FETCH o.items WHERE o.id = :id")
    Optional<Order> findByIdWithItemsTimeout(@Param("id") Long id);
}
```

| Hint | Effect |
|------|--------|
| `org.hibernate.readOnly` | Skip dirty checking for returned entities |
| `org.hibernate.fetchSize` | JDBC fetch size (rows buffered from DB) |
| `org.hibernate.comment` | SQL comment (visible in slow query log) |
| `jakarta.persistence.query.timeout` | Query timeout in milliseconds |
| `org.hibernate.cacheable` | Cache query results (requires query cache enabled) |

---

## Hibernate Statistics

### Enable
```yaml
spring:
  jpa:
    properties:
      hibernate:
        generate_statistics: true

logging:
  level:
    org.hibernate.stat: DEBUG
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
```

### Access Programmatically
```java
@Component
public class HibernateMetrics implements MeterBinder {
    @PersistenceUnit
    private EntityManagerFactory emf;

    @Override
    public void bindTo(MeterRegistry registry) {
        var stats = emf.unwrap(SessionFactory.class).getStatistics();
        Gauge.builder("hibernate.sessions.open", stats, Statistics::getSessionOpenCount)
            .register(registry);
        Gauge.builder("hibernate.queries.executed", stats, Statistics::getQueryExecutionCount)
            .register(registry);
        Gauge.builder("hibernate.cache.hit.ratio", stats, s ->
            s.getSecondLevelCacheHitCount() /
            (double) Math.max(1, s.getSecondLevelCacheHitCount() + s.getSecondLevelCacheMissCount()))
            .register(registry);
    }
}
```

### Slow Query Logging
```yaml
spring:
  jpa:
    properties:
      hibernate:
        session:
          events:
            log:
              LOG_QUERIES_SLOWER_THAN_MS: 100
```

---

## Connection Pool Tuning (HikariCP)

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      idle-timeout: 300000         # 5 min
      max-lifetime: 1800000        # 30 min
      connection-timeout: 30000    # 30 sec
      leak-detection-threshold: 60000  # warn if connection held > 60s
```

### Sizing Rule of Thumb
```
pool_size = (core_count * 2) + effective_spindle_count
```
For cloud databases with SSDs, start with **10-20** connections and adjust based on metrics.

### Statement Caching
```yaml
spring:
  datasource:
    hikari:
      data-source-properties:
        cachePrepStmts: true
        prepStmtCacheSize: 250
        prepStmtCacheSqlLimit: 2048
```
