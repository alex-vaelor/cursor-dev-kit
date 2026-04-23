# Hibernate Envers

Audit entity history by tracking all changes in revision tables.

## When to Use Envers

| Use Envers | Use Alternatives |
|-----------|-----------------|
| Need full change history of entities | Only need created/updated timestamps (`@CreatedDate`, `@LastModifiedDate`) |
| Regulatory/compliance audit trail | Event sourcing is the core architecture pattern |
| "Who changed what and when" queries | Simple soft-delete tracking |
| Point-in-time entity state reconstruction | Only need the latest version |

## Setup

### Dependencies
```xml
<dependency>
  <groupId>org.springframework.data</groupId>
  <artifactId>spring-data-envers</artifactId>
</dependency>
```
This pulls in `hibernate-envers` transitively.

### Enable
```java
@Configuration
@EnableJpaRepositories(repositoryFactoryBeanClass = EnversRevisionRepositoryFactoryBean.class)
public class EnversConfig { }
```

## Entity Auditing

### Basic Auditing
```java
@Entity
@Audited
@Table(name = "orders")
public class Order {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String description;
    private BigDecimal total;

    @Enumerated(EnumType.STRING)
    private OrderStatus status;

    @NotAudited // skip auditing for this field
    @OneToMany(mappedBy = "order")
    private List<OrderItem> items;
}
```

### Selective Auditing
```java
@Entity
@Audited
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;  // audited
    private String email;     // audited

    @NotAudited
    private String avatarUrl; // not audited (changes too frequently)

    @NotAudited
    @Transient
    private String sessionToken; // transient + not audited
}
```

## Revision Tables

Envers creates:
- `{entity}_AUD` table for each `@Audited` entity (mirrors columns + `REV` + `REVTYPE`)
- `REVINFO` table storing revision metadata (revision number, timestamp)

### REVTYPE Values
| Value | Meaning |
|-------|---------|
| 0 | INSERT (entity created) |
| 1 | UPDATE (entity modified) |
| 2 | DELETE (entity deleted) |

### Custom Revision Entity
```java
@Entity
@RevisionEntity(CustomRevisionListener.class)
@Table(name = "revision_info")
public class CustomRevisionEntity extends DefaultRevisionEntity {

    @Column(name = "modified_by")
    private String modifiedBy;

    @Column(name = "ip_address")
    private String ipAddress;
}

public class CustomRevisionListener implements RevisionListener {
    @Override
    public void newRevision(Object revisionEntity) {
        var rev = (CustomRevisionEntity) revisionEntity;
        var auth = SecurityContextHolder.getContext().getAuthentication();
        rev.setModifiedBy(auth != null ? auth.getName() : "system");
        // IP can be obtained via RequestContextHolder if needed
    }
}
```

## Querying History

### Using AuditReader
```java
@Service
@Transactional(readOnly = true)
public class OrderAuditService {
    @PersistenceContext
    private EntityManager entityManager;

    public Order getOrderAtRevision(Long orderId, int revision) {
        var reader = AuditReaderFactory.get(entityManager);
        return reader.find(Order.class, orderId, revision);
    }

    public List<Number> getRevisions(Long orderId) {
        var reader = AuditReaderFactory.get(entityManager);
        return reader.getRevisions(Order.class, orderId);
    }

    public List<Object[]> getOrderHistory(Long orderId) {
        var reader = AuditReaderFactory.get(entityManager);
        return reader.createQuery()
            .forRevisionsOfEntity(Order.class, false, true)
            .add(AuditEntity.id().eq(orderId))
            .addOrder(AuditEntity.revisionNumber().desc())
            .getResultList();
    }

    public List<Order> getOrdersAtPointInTime(Instant timestamp) {
        var reader = AuditReaderFactory.get(entityManager);
        long epochMillis = timestamp.toEpochMilli();
        Number rev = reader.getRevisionNumberForDate(Date.from(timestamp));
        return reader.createQuery()
            .forEntitiesAtRevision(Order.class, rev)
            .getResultList();
    }
}
```

### Spring Data Envers Repository
```java
public interface OrderRepository extends JpaRepository<Order, Long>,
    RevisionRepository<Order, Long, Integer> {
}

// Usage
@Transactional(readOnly = true)
public List<OrderRevisionDto> getOrderHistory(Long orderId) {
    return orderRepository.findRevisions(orderId).stream()
        .map(rev -> new OrderRevisionDto(
            rev.getEntity().getId(),
            rev.getEntity().getDescription(),
            rev.getEntity().getStatus(),
            rev.getMetadata().getRevisionType(),
            rev.getMetadata().getRevisionInstant().orElse(null)
        ))
        .toList();
}

// Latest change
public Optional<Order> getLastChange(Long orderId) {
    return orderRepository.findLastChangeRevision(orderId)
        .map(Revision::getEntity);
}
```

## Performance Considerations

### Audit Table Indexing
```sql
-- Essential indexes for _AUD tables
CREATE INDEX idx_orders_aud_rev ON orders_aud (rev);
CREATE INDEX idx_orders_aud_id ON orders_aud (id);
CREATE INDEX idx_orders_aud_id_rev ON orders_aud (id, rev);
```

### Partition Strategy
For high-volume audit tables:
```sql
-- Partition by revision range (PostgreSQL)
CREATE TABLE orders_aud (
    id BIGINT, rev INTEGER, revtype SMALLINT,
    description VARCHAR(500), total NUMERIC(19,2), status VARCHAR(20)
) PARTITION BY RANGE (rev);

CREATE TABLE orders_aud_q1 PARTITION OF orders_aud FOR VALUES FROM (1) TO (1000000);
CREATE TABLE orders_aud_q2 PARTITION OF orders_aud FOR VALUES FROM (1000000) TO (2000000);
```

### Configuration Tuning
```yaml
spring:
  jpa:
    properties:
      org:
        hibernate:
          envers:
            store_data_at_delete: true      # store entity state on delete (useful for compliance)
            audit_strategy: org.hibernate.envers.strategy.ValidityAuditStrategy  # better query perf
            global_with_modified_flag: true  # track which fields changed per revision
```

## Testing Envers

```java
@DataJpaTest
@Import(EnversConfig.class)
class OrderAuditTest {
    @Autowired private OrderRepository orderRepository;
    @PersistenceContext private EntityManager entityManager;

    @Test
    void shouldTrackOrderChanges() {
        var order = new Order("Initial description", BigDecimal.TEN);
        orderRepository.saveAndFlush(order);

        order.setDescription("Updated description");
        orderRepository.saveAndFlush(order);

        var revisions = orderRepository.findRevisions(order.getId());
        assertThat(revisions).hasSize(2);
        assertThat(revisions.getContent().getFirst().getMetadata().getRevisionType())
            .isEqualTo(RevisionType.INSERT);
        assertThat(revisions.getContent().getLast().getMetadata().getRevisionType())
            .isEqualTo(RevisionType.UPDATE);
    }
}
```
