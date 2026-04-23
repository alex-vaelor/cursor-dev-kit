# Advanced Entity Mapping

## @Embeddable / @Embedded

### Value Objects as Embeddables
```java
@Embeddable
public record Money(
    @Column(nullable = false, precision = 19, scale = 2) BigDecimal amount,
    @Column(nullable = false, length = 3) String currency
) {}

@Embeddable
public record Address(
    @Column(nullable = false) String street,
    @Column(nullable = false) String city,
    @Column(nullable = false, length = 10) String postalCode,
    @Column(nullable = false, length = 2) String countryCode
) {}
```

### Using Embeddables in Entities
```java
@Entity
@Table(name = "orders")
public class Order {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Embedded
    private Money totalPrice;

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "street", column = @Column(name = "shipping_street")),
        @AttributeOverride(name = "city", column = @Column(name = "shipping_city")),
        @AttributeOverride(name = "postalCode", column = @Column(name = "shipping_postal_code")),
        @AttributeOverride(name = "countryCode", column = @Column(name = "shipping_country"))
    })
    private Address shippingAddress;

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "street", column = @Column(name = "billing_street")),
        @AttributeOverride(name = "city", column = @Column(name = "billing_city")),
        @AttributeOverride(name = "postalCode", column = @Column(name = "billing_postal_code")),
        @AttributeOverride(name = "countryCode", column = @Column(name = "billing_country"))
    })
    private Address billingAddress;
}
```

### Collections of Embeddables
```java
@Entity
public class Customer {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ElementCollection
    @CollectionTable(name = "customer_addresses", joinColumns = @JoinColumn(name = "customer_id"))
    private Set<Address> addresses = new HashSet<>();
}
```
`@ElementCollection` creates a separate table owned by the parent. Lifecycle is fully managed by the parent (no independent identity).

---

## Inheritance Strategies

### Decision Guide
| Strategy | Table Layout | Polymorphic Queries | Performance | Nullability |
|----------|-------------|--------------------|----|-------------|
| `SINGLE_TABLE` | One table, discriminator column | Fast (single table) | Best | Subclass columns nullable |
| `JOINED` | One table per class, joined | Medium (requires joins) | Good for deep hierarchies | Proper NOT NULL |
| `TABLE_PER_CLASS` | One table per concrete class | Slow (UNION ALL) | Poor for polymorphic queries | Proper NOT NULL |
| `@MappedSuperclass` | No inheritance table | Not supported | N/A | N/A |

### SINGLE_TABLE (Default, Recommended)
```java
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "payment_type", discriminatorType = DiscriminatorType.STRING)
public abstract class Payment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private BigDecimal amount;

    @Column(nullable = false)
    private Instant paidAt;
}

@Entity
@DiscriminatorValue("CREDIT_CARD")
public class CreditCardPayment extends Payment {
    @Column(length = 4)
    private String lastFourDigits;
    private String cardBrand;
}

@Entity
@DiscriminatorValue("BANK_TRANSFER")
public class BankTransferPayment extends Payment {
    private String bankName;
    private String referenceNumber;
}
```

### JOINED (Normalized)
```java
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Notification {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String message;
    private Instant sentAt;
}

@Entity
@Table(name = "email_notifications")
public class EmailNotification extends Notification {
    @Column(nullable = false)
    private String toAddress;
    private String subject;
}

@Entity
@Table(name = "sms_notifications")
public class SmsNotification extends Notification {
    @Column(nullable = false)
    private String phoneNumber;
}
```
Use JOINED when subclass fields have strict NOT NULL constraints and the hierarchy is queried polymorphically.

### @MappedSuperclass (No Polymorphic Queries)
```java
@MappedSuperclass
public abstract class BaseEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @LastModifiedDate
    @Column(nullable = false)
    private Instant updatedAt;

    @Version
    private Long version;
}

@Entity
public class Order extends BaseEntity {
    private String description;
}

@Entity
public class Product extends BaseEntity {
    private String name;
}
```
`@MappedSuperclass` shares fields but not a JPA inheritance table. You cannot query `BaseEntity` polymorphically.

---

## @AttributeConverter

### Custom Type Conversions
```java
@Converter(autoApply = true)
public class MoneyConverter implements AttributeConverter<Money, String> {
    @Override
    public String convertToDatabaseColumn(Money money) {
        return money == null ? null : money.amount().toPlainString() + " " + money.currency();
    }

    @Override
    public Money convertToEntityAttribute(String dbData) {
        if (dbData == null) return null;
        var parts = dbData.split(" ");
        return new Money(new BigDecimal(parts[0]), parts[1]);
    }
}
```

### Enum Converter (Custom Mapping)
```java
@Converter(autoApply = true)
public class OrderStatusConverter implements AttributeConverter<OrderStatus, String> {
    @Override
    public String convertToDatabaseColumn(OrderStatus status) {
        return status == null ? null : status.getCode();
    }

    @Override
    public OrderStatus convertToEntityAttribute(String code) {
        return code == null ? null : OrderStatus.fromCode(code);
    }
}
```
Use `@Converter(autoApply = true)` to apply globally without annotating every field. Prefer this over `@Enumerated(EnumType.STRING)` when the DB value differs from the enum name.

---

## Composite Keys

### @EmbeddedId (Preferred)
```java
@Embeddable
public record OrderItemId(
    @Column(name = "order_id") Long orderId,
    @Column(name = "product_id") Long productId
) implements Serializable {}

@Entity
@Table(name = "order_items")
public class OrderItem {
    @EmbeddedId
    private OrderItemId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("orderId")
    private Order order;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("productId")
    private Product product;

    private int quantity;
}
```

### @IdClass (Alternative)
```java
public record OrderItemId(Long orderId, Long productId) implements Serializable {}

@Entity
@IdClass(OrderItemId.class)
public class OrderItem {
    @Id @Column(name = "order_id") private Long orderId;
    @Id @Column(name = "product_id") private Long productId;
    private int quantity;
}
```

### When to Use Composite Keys
- Join tables with extra attributes (`order_items` with `quantity`)
- Legacy databases with compound primary keys
- Prefer surrogate `@Id` + unique constraint for new designs

---

## Collection Mapping

### Set vs List Performance
| Collection | Duplicates | Order | Performance for add/remove |
|-----------|------------|-------|--------------------------|
| `Set<T>` | No | Unordered | Fast (no full load for add) |
| `List<T>` | Yes | Ordered | Slower (Hibernate may delete-all + re-insert on change) |

**Prefer `Set<T>`** for `@OneToMany` and `@ManyToMany` unless ordering is required.

### Ordering
```java
@OneToMany(mappedBy = "order")
@OrderBy("createdAt DESC")
private Set<OrderItem> items = new LinkedHashSet<>();

@ElementCollection
@OrderBy("city ASC")
private List<Address> addresses;
```

### @MapKey
```java
@OneToMany(mappedBy = "order")
@MapKey(name = "sku")
private Map<String, OrderItem> itemsBySku = new HashMap<>();
```

---

## Hibernate-Specific Annotations

### @Formula (Computed Column)
```java
@Entity
public class Order {
    @Formula("(SELECT COUNT(*) FROM order_items oi WHERE oi.order_id = id)")
    private int itemCount;

    @Formula("(SELECT SUM(oi.quantity * oi.unit_price) FROM order_items oi WHERE oi.order_id = id)")
    private BigDecimal calculatedTotal;
}
```
`@Formula` executes a SQL subquery on every entity load. Use for read-only derived values.

### @Where (Soft Delete Filter)
```java
@Entity
@Where(clause = "deleted = false")
public class Product {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private boolean deleted = false;

    public void softDelete() { this.deleted = true; }
}
```

### @Filter (Dynamic Filtering)
```java
@Entity
@FilterDef(name = "activeOnly", defaultCondition = "active = true")
@Filter(name = "activeOnly")
public class Subscription {
    private boolean active;
}

// Enable filter in service
entityManager.unwrap(Session.class).enableFilter("activeOnly");
```
`@Filter` is dynamic (enabled/disabled at runtime); `@Where` is always applied.
