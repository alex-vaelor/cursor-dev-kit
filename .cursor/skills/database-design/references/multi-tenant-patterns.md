# Multi-Tenant Database Patterns for Java/Spring Boot

## Tenancy Models

| Model | Isolation | Cost | Complexity | Best For |
|-------|-----------|------|------------|----------|
| **Database per tenant** | Complete | High | Medium | Strict compliance (HIPAA, PCI) |
| **Schema per tenant** | Strong | Medium | Medium | Moderate isolation needs |
| **Shared schema (Row-Level Security)** | Moderate | Low | Low-Medium | Cost-sensitive, many tenants |
| **Shared schema (Discriminator column)** | Low | Lowest | Low | Simple SaaS, low risk |

## Shared Schema with `tenant_id` (Most Common)

### Entity Design
```java
@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tenant_id", nullable = false, updatable = false)
    private UUID tenantId;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private BigDecimal total;

    // Constructors, getters...
}
```

### Hibernate Tenant Identifier Resolution
```java
public class TenantIdentifierResolver implements CurrentTenantIdentifierResolver<String> {
    @Override
    public String resolveCurrentTenantIdentifier() {
        return TenantContext.getCurrentTenant()
            .orElseThrow(() -> new IllegalStateException("No tenant in context"));
    }

    @Override
    public boolean validateExistingCurrentSessions() {
        return true;
    }
}
```

### Tenant Context (Thread-Local + Virtual Thread Safe)
```java
public final class TenantContext {
    private static final ScopedValue<String> TENANT = ScopedValue.newInstance();

    private TenantContext() {}

    public static Optional<String> getCurrentTenant() {
        return TENANT.isBound() ? Optional.of(TENANT.get()) : Optional.empty();
    }

    public static <T> T executeInTenantScope(String tenantId, Callable<T> callable) throws Exception {
        return ScopedValue.callWhere(TENANT, tenantId, callable);
    }
}
```

### Spring Filter for Tenant Extraction
```java
@Component
public class TenantFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain filterChain) throws ServletException, IOException {
        String tenantId = request.getHeader("X-Tenant-ID");
        if (tenantId == null || tenantId.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "X-Tenant-ID header required");
            return;
        }

        try {
            ScopedValue.runWhere(TenantContext.TENANT, tenantId,
                () -> filterChain.doFilter(request, response));
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
```

## PostgreSQL Row-Level Security (RLS)

RLS provides database-enforced tenant isolation -- even if application code has a bug, data cannot leak across tenants.

### Migration: Enable RLS
```sql
-- V1__create_orders_table.sql
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    tenant_id UUID NOT NULL,
    description TEXT NOT NULL,
    total NUMERIC(19,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_orders_tenant_id ON orders(tenant_id);

-- V2__enable_rls.sql
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON orders
    USING (tenant_id = current_setting('app.current_tenant')::uuid);

CREATE POLICY tenant_insert ON orders
    FOR INSERT WITH CHECK (tenant_id = current_setting('app.current_tenant')::uuid);
```

### Setting Tenant in Connection
```java
@Component
public class TenantConnectionPreparer implements ConnectionPreparedStatementCallback {
    @Override
    public void prepare(Connection connection) throws SQLException {
        String tenantId = TenantContext.getCurrentTenant()
            .orElseThrow(() -> new SQLException("No tenant in context"));

        try (var stmt = connection.createStatement()) {
            stmt.execute("SET app.current_tenant = '" + tenantId + "'");
        }
    }
}
```

A safer approach using Spring's `JdbcClient`:
```java
@Repository
public class TenantAwareJdbcOperations {
    private final JdbcClient jdbcClient;

    public void setTenantContext(UUID tenantId) {
        jdbcClient.sql("SELECT set_config('app.current_tenant', :tenantId, true)")
            .param("tenantId", tenantId.toString())
            .query();
    }
}
```

## Database Per Tenant (Hibernate Multi-Tenancy)

### Configuration
```yaml
spring:
  jpa:
    properties:
      hibernate:
        multiTenancy: DATABASE
        tenant_identifier_resolver: com.example.TenantIdentifierResolver
        multi_tenant_connection_provider: com.example.TenantConnectionProvider
```

### Connection Provider
```java
public class TenantConnectionProvider implements MultiTenantConnectionProvider<String> {
    private final Map<String, DataSource> dataSources;

    @Override
    public Connection getConnection(String tenantId) throws SQLException {
        var ds = dataSources.get(tenantId);
        if (ds == null) throw new TenantNotFoundException(tenantId);
        return ds.getConnection();
    }

    @Override
    public void releaseConnection(String tenantId, Connection connection) throws SQLException {
        connection.close();
    }
}
```

## Testing Multi-Tenant Applications

```java
@SpringBootTest
@Testcontainers
class MultiTenantOrderRepositoryTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @Test
    void shouldIsolateTenantData() {
        UUID tenantA = UUID.randomUUID();
        UUID tenantB = UUID.randomUUID();

        TenantContext.executeInTenantScope(tenantA.toString(), () -> {
            orderRepository.save(new Order(tenantA, "Order A", BigDecimal.TEN));
            return null;
        });

        TenantContext.executeInTenantScope(tenantB.toString(), () -> {
            var orders = orderRepository.findAll();
            assertThat(orders).isEmpty();
            return null;
        });
    }
}
```

## Operational Pitfalls

| Pitfall | Mitigation |
|---------|------------|
| Missing `tenant_id` in queries | Use RLS to enforce at DB level; add ArchUnit test for entity design |
| Data leak across tenants | RLS + integration tests with multiple tenants |
| Tenant context lost in async operations | Use `ScopedValue` (Java 21) instead of `ThreadLocal` |
| Expensive cross-tenant queries | Separate analytics database; never query across tenants in application |
| Migration applied to wrong tenant DB | Flyway per-tenant migration strategy; test in staging first |
