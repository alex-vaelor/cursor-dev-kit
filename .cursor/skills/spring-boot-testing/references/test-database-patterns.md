# Test Database Patterns: H2 vs Testcontainers

## Decision Guide

| Criterion | H2 (In-Memory) | Testcontainers |
|-----------|----------------|----------------|
| **Speed** | Very fast (no container startup) | Slower (container start ~2-5s with reuse) |
| **Fidelity** | Approximate (compatibility modes) | Exact (same DB as production) |
| **SQL dialect** | H2 SQL + compatibility mode | Native PostgreSQL/MySQL/etc. |
| **Migrations** | May diverge from production | Flyway runs against real DB |
| **CI complexity** | No Docker required | Docker required |
| **Extensions** | Not available | Full (pg_trgm, PostGIS, etc.) |

### When to Use H2
- `@DataJpaTest` or `@DataJdbcTest` for fast repository unit tests
- Testing basic CRUD that doesn't use DB-specific features
- Environments where Docker is not available
- Rapid feedback during local development

### When to Use Testcontainers
- Integration tests that test Flyway migrations
- Queries using database-specific features (window functions, CTEs, JSON operators)
- Tests that verify PostgreSQL-specific behavior (RLS, partial indexes, JSONB)
- Acceptance tests that mirror production behavior

## H2 Configuration

### PostgreSQL Compatibility Mode
```yaml
# application-test.yml
spring:
  datasource:
    url: jdbc:h2:mem:testdb;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DEFAULT_NULL_ORDERING=HIGH
    driver-class-name: org.h2.Driver
  jpa:
    database-platform: org.hibernate.dialect.H2Dialect
```

### Limitations of Compatibility Mode
- No PostgreSQL extensions (pg_trgm, PostGIS)
- No row-level security (RLS)
- Some window function differences
- JSONB operations differ
- Sequence behavior may vary

## Testcontainers Configuration

### Spring Boot 3.1+ with @ServiceConnection
```java
@SpringBootTest
@Testcontainers
class OrderRepositoryIT {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired
    private OrderRepository orderRepository;

    @Test
    void shouldSaveAndRetrieveOrder() {
        var order = new Order("Test order", BigDecimal.TEN);
        var saved = orderRepository.save(order);
        var found = orderRepository.findById(saved.getId());
        assertThat(found).isPresent().get()
            .extracting(Order::getDescription).isEqualTo("Test order");
    }
}
```

### Reusable Containers (Faster CI)
```java
public abstract class BaseIntegrationTest {
    @Container
    @ServiceConnection
    protected static final PostgreSQLContainer<?> postgres =
        new PostgreSQLContainer<>("postgres:16-alpine")
            .withReuse(true);
}

class OrderRepositoryIT extends BaseIntegrationTest {
    // inherits container
}
```

Enable reuse in `~/.testcontainers.properties`:
```
testcontainers.reuse.enable=true
```

### Multiple Containers
```java
@SpringBootTest
@Testcontainers
class FullStackIT {
    @Container @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Container @ServiceConnection
    static GenericContainer<?> redis = new GenericContainer<>("redis:7-alpine")
        .withExposedPorts(6379);
}
```

## Test Data Setup Patterns

### @Sql Annotation
```java
@Test
@Sql("/test-data/orders.sql")
@Sql(statements = "DELETE FROM orders", executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD)
void shouldFindOrdersByCustomer() {
    var orders = orderRepository.findByCustomerId(1L);
    assertThat(orders).hasSize(3);
}
```

### Test Data Builders
```java
public class TestOrderBuilder {
    private String description = "Test Order";
    private BigDecimal total = BigDecimal.TEN;
    private OrderStatus status = OrderStatus.PENDING;

    public static TestOrderBuilder anOrder() { return new TestOrderBuilder(); }
    public TestOrderBuilder withDescription(String d) { this.description = d; return this; }
    public TestOrderBuilder withTotal(BigDecimal t) { this.total = t; return this; }
    public TestOrderBuilder withStatus(OrderStatus s) { this.status = s; return this; }
    public Order build() { return new Order(description, total, status); }
}
```

### Transaction Rollback
By default, `@DataJpaTest` and `@Transactional` test classes roll back after each test, keeping the database clean.

## Recommended Strategy

```
Unit tests (fast)     → H2 with @DataJpaTest / @DataJdbcTest
Integration tests     → Testcontainers with @SpringBootTest
Migration tests       → Testcontainers (verify Flyway against real DB)
Acceptance tests      → Testcontainers (production-like stack)
```
