# Java Design Patterns Guide

Design patterns adapted for modern Java (17/21) with records, sealed classes, lambdas, and Spring integration.

## Creational Patterns

### Factory Method with Sealed Types

```java
public sealed interface Notification permits EmailNotification, SmsNotification, PushNotification {
    void send(String recipient, String message);
}

public record EmailNotification(EmailService emailService) implements Notification {
    public void send(String recipient, String message) {
        emailService.send(recipient, message);
    }
}

public record SmsNotification(SmsGateway gateway) implements Notification {
    public void send(String recipient, String message) {
        gateway.sendSms(recipient, message);
    }
}

public record PushNotification(PushService pushService) implements Notification {
    public void send(String recipient, String message) {
        pushService.push(recipient, message);
    }
}

// Factory using switch expression (exhaustive)
public Notification create(NotificationType type) {
    return switch (type) {
        case EMAIL -> new EmailNotification(emailService);
        case SMS -> new SmsNotification(smsGateway);
        case PUSH -> new PushNotification(pushService);
    };
}
```

### Builder for Complex Objects

```java
public record ServerConfig(
    String host, int port, boolean ssl,
    Duration connectionTimeout, Duration readTimeout,
    int maxConnections
) {
    public static Builder builder(String host, int port) {
        return new Builder(host, port);
    }

    public static final class Builder {
        private final String host;
        private final int port;
        private boolean ssl = false;
        private Duration connectionTimeout = Duration.ofSeconds(5);
        private Duration readTimeout = Duration.ofSeconds(30);
        private int maxConnections = 100;

        private Builder(String host, int port) {
            this.host = host;
            this.port = port;
        }

        public Builder ssl(boolean ssl) { this.ssl = ssl; return this; }
        public Builder connectionTimeout(Duration t) { this.connectionTimeout = t; return this; }
        public Builder readTimeout(Duration t) { this.readTimeout = t; return this; }
        public Builder maxConnections(int n) { this.maxConnections = n; return this; }

        public ServerConfig build() {
            return new ServerConfig(host, port, ssl, connectionTimeout, readTimeout, maxConnections);
        }
    }
}
```

## Structural Patterns

### Decorator with Spring

```java
public interface PricingService {
    BigDecimal calculatePrice(Order order);
}

@Service
@Primary
public class DiscountPricingService implements PricingService {
    private final PricingService delegate;
    private final DiscountRepository discountRepo;

    public DiscountPricingService(
        @Qualifier("basePricing") PricingService delegate,
        DiscountRepository discountRepo
    ) {
        this.delegate = delegate;
        this.discountRepo = discountRepo;
    }

    public BigDecimal calculatePrice(Order order) {
        BigDecimal base = delegate.calculatePrice(order);
        return discountRepo.findActiveDiscount(order.customerId())
            .map(d -> base.multiply(BigDecimal.ONE.subtract(d.rate())))
            .orElse(base);
    }
}

@Service("basePricing")
public class BasePricingService implements PricingService {
    public BigDecimal calculatePrice(Order order) {
        return order.items().stream()
            .map(Item::price)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
```

## Behavioral Patterns

### Strategy with Functional Interfaces

```java
@FunctionalInterface
public interface SortStrategy<T> {
    List<T> sort(List<T> items);
}

@Service
public class ProductService {
    private final Map<String, SortStrategy<Product>> strategies = Map.of(
        "price", items -> items.stream().sorted(comparing(Product::price)).toList(),
        "name", items -> items.stream().sorted(comparing(Product::name)).toList(),
        "rating", items -> items.stream().sorted(comparing(Product::rating).reversed()).toList()
    );

    public List<Product> getProducts(String sortBy) {
        var strategy = strategies.getOrDefault(sortBy, strategies.get("name"));
        return strategy.sort(productRepository.findAll());
    }
}
```

### Observer with Spring Events

```java
public record OrderPlacedEvent(String orderId, String customerId, BigDecimal total) {}

@Service
public class OrderService {
    private final ApplicationEventPublisher events;

    public OrderService(ApplicationEventPublisher events) {
        this.events = events;
    }

    public void placeOrder(OrderRequest request) {
        Order order = createOrder(request);
        events.publishEvent(new OrderPlacedEvent(order.id(), order.customerId(), order.total()));
    }
}

@Component
public class InventoryListener {
    @EventListener
    public void onOrderPlaced(OrderPlacedEvent event) {
        // Update inventory
    }
}

@Component
public class NotificationListener {
    @Async
    @EventListener
    public void onOrderPlaced(OrderPlacedEvent event) {
        // Send confirmation email
    }
}
```

### Command with Sealed Records

```java
public sealed interface Command permits CreateUser, UpdateEmail, DeactivateUser {
    String userId();
}

public record CreateUser(String userId, String name, String email) implements Command {}
public record UpdateEmail(String userId, String newEmail) implements Command {}
public record DeactivateUser(String userId, String reason) implements Command {}

public void handle(Command command) {
    switch (command) {
        case CreateUser c -> userService.create(c.userId(), c.name(), c.email());
        case UpdateEmail c -> userService.updateEmail(c.userId(), c.newEmail());
        case DeactivateUser c -> userService.deactivate(c.userId(), c.reason());
    }
}
```

---

## Additional GoF Patterns

### Bridge (Structural)

**Intent**: Decouple an abstraction from its implementation so both can vary independently.

```java
public interface MessageSender {
    void send(String message, String recipient);
}

public record SmsSender(SmsGateway gateway) implements MessageSender {
    public void send(String message, String recipient) {
        gateway.sendSms(recipient, message);
    }
}

public record EmailSender(EmailClient client) implements MessageSender {
    public void send(String message, String recipient) {
        client.sendEmail(recipient, "Notification", message);
    }
}

public sealed interface Notification permits UrgentNotification, StandardNotification {
    void notifyUser(String userId);
}

public record UrgentNotification(MessageSender sender, String message) implements Notification {
    public void notifyUser(String userId) {
        sender.send("[URGENT] " + message, userId);
    }
}

public record StandardNotification(MessageSender sender, String message) implements Notification {
    public void notifyUser(String userId) {
        sender.send(message, userId);
    }
}
```

**When to use**: Abstraction and implementation should evolve independently (e.g., notifications via SMS or email, each with urgent or standard priority).
**Spring context**: Driver/DataSource separation; RestClient vs WebClient behind a common port interface.

### Composite (Structural)

**Intent**: Compose objects into tree structures; clients treat individual objects and compositions uniformly.

```java
public sealed interface PriceRule permits FixedDiscount, PercentageDiscount, CompositePriceRule {
    BigDecimal apply(BigDecimal price);
}

public record FixedDiscount(BigDecimal amount) implements PriceRule {
    public BigDecimal apply(BigDecimal price) {
        return price.subtract(amount).max(BigDecimal.ZERO);
    }
}

public record PercentageDiscount(BigDecimal percentage) implements PriceRule {
    public BigDecimal apply(BigDecimal price) {
        return price.multiply(BigDecimal.ONE.subtract(percentage));
    }
}

public record CompositePriceRule(List<PriceRule> rules) implements PriceRule {
    public BigDecimal apply(BigDecimal price) {
        var result = price;
        for (var rule : rules) {
            result = rule.apply(result);
        }
        return result;
    }
}
```

**When to use**: Tree-like hierarchies (menus, organizational charts, composite pricing rules, permission trees).
**Spring context**: Spring Security `AuthorizationManager` compositions.

### Flyweight (Structural)

**Intent**: Share fine-grained objects to reduce memory usage when many similar objects exist.

```java
public record CurrencySymbol(String code, String symbol, int decimalPlaces) {}

public class CurrencySymbolFactory {
    private static final Map<String, CurrencySymbol> CACHE = new ConcurrentHashMap<>();

    public static CurrencySymbol of(String code) {
        return CACHE.computeIfAbsent(code, c -> switch (c) {
            case "USD" -> new CurrencySymbol("USD", "$", 2);
            case "EUR" -> new CurrencySymbol("EUR", "€", 2);
            case "JPY" -> new CurrencySymbol("JPY", "¥", 0);
            default -> throw new IllegalArgumentException("Unknown currency: " + c);
        });
    }
}
```

**When to use**: Many objects share intrinsic state (currency definitions, font glyphs, connection pool metadata).
**Spring context**: Spring bean scope `singleton` is essentially the Flyweight pattern. `Integer.valueOf()` caching (-128 to 127) is a JDK example.

### Template Method (Behavioral)

**Intent**: Define the skeleton of an algorithm, letting subclasses override specific steps.

```java
public abstract class DataImporter<T> {
    public final ImportResult importData(InputStream source) {
        var rawRecords = parse(source);
        var validated = rawRecords.stream().filter(this::validate).toList();
        var transformed = validated.stream().map(this::transform).toList();
        return save(transformed);
    }

    protected abstract List<T> parse(InputStream source);
    protected abstract boolean validate(T record);
    protected abstract T transform(T record);
    protected abstract ImportResult save(List<T> records);
}

public class CsvOrderImporter extends DataImporter<OrderRecord> {
    @Override protected List<OrderRecord> parse(InputStream source) { /* CSV parsing */ }
    @Override protected boolean validate(OrderRecord record) { /* validation rules */ }
    @Override protected OrderRecord transform(OrderRecord record) { /* normalization */ }
    @Override protected ImportResult save(List<OrderRecord> records) { /* batch save */ }
}
```

**When to use**: Multiple implementations share the same algorithm structure but differ in specific steps.
**Spring context**: `AbstractRoutingDataSource`, `JdbcTemplate` callback methods, `WebSecurityConfigurerAdapter` (deprecated but illustrative).
**Modern alternative**: Prefer composition with `Function`/`Consumer` parameters or Strategy pattern when the algorithm has few steps.

### Iterator (Behavioral)

**Intent**: Provide sequential access to elements without exposing the underlying data structure.

```java
public record PageIterator<T>(Function<Integer, Page<T>> pageFetcher) implements Iterator<List<T>> {
    private int currentPage = 0;
    private boolean hasMore = true;

    @Override
    public boolean hasNext() { return hasMore; }

    @Override
    public List<T> next() {
        var page = pageFetcher.apply(currentPage++);
        hasMore = page.hasNext();
        return page.getContent();
    }
}

// Usage: iterate over all pages of results
var iterator = new PageIterator<Order>(page -> orderRepository.findAll(PageRequest.of(page, 100)));
while (iterator.hasNext()) {
    var batch = iterator.next();
    processBatch(batch);
}
```

**When to use**: Custom iteration over paginated data, lazy-loaded sequences, or domain-specific traversal.
**Spring context**: Spring Data `Page` and `Slice` provide built-in iteration. `ResultSet` iteration in JdbcTemplate.
**Modern alternative**: `Stream` and `Iterable` cover most cases; custom iterators are rarely needed.

### Mediator (Behavioral)

**Intent**: Define an object that encapsulates how a set of objects interact; promotes loose coupling.

```java
public interface OrderMediator {
    void onOrderCreated(Order order);
    void onPaymentCompleted(Long orderId);
    void onShipmentReady(Long orderId);
}

@Service
public class OrderWorkflowMediator implements OrderMediator {
    private final InventoryService inventoryService;
    private final PaymentService paymentService;
    private final ShippingService shippingService;
    private final NotificationService notificationService;

    @Override
    public void onOrderCreated(Order order) {
        inventoryService.reserve(order);
        paymentService.requestPayment(order);
    }

    @Override
    public void onPaymentCompleted(Long orderId) {
        shippingService.scheduleShipment(orderId);
        notificationService.sendPaymentConfirmation(orderId);
    }

    @Override
    public void onShipmentReady(Long orderId) {
        notificationService.sendShippingNotification(orderId);
    }
}
```

**When to use**: Multiple objects interact with complex interdependencies; centralize coordination.
**Spring context**: `ApplicationEventPublisher` acts as a mediator. Spring Integration `MessageChannel`.

### Memento (Behavioral)

**Intent**: Capture and externalize an object's internal state so it can be restored later.

```java
public record OrderMemento(Long orderId, OrderStatus status, BigDecimal total, Instant timestamp) {}

@Entity
public class Order {
    private Long id;
    private OrderStatus status;
    private BigDecimal total;

    public OrderMemento createMemento() {
        return new OrderMemento(id, status, total, Instant.now());
    }

    public void restore(OrderMemento memento) {
        this.status = memento.status();
        this.total = memento.total();
    }
}

@Service
public class OrderAuditService {
    private final Map<Long, Deque<OrderMemento>> history = new ConcurrentHashMap<>();

    public void saveState(Order order) {
        history.computeIfAbsent(order.getId(), k -> new ArrayDeque<>()).push(order.createMemento());
    }

    public void undo(Order order) {
        var stack = history.get(order.getId());
        if (stack != null && !stack.isEmpty()) {
            order.restore(stack.pop());
        }
    }
}
```

**When to use**: Undo/redo functionality, audit trails, state snapshots before risky operations.
**Spring context**: Event sourcing captures state changes as events (richer form of Memento).

### Visitor (Behavioral)

**Intent**: Add new operations to a type hierarchy without modifying existing classes.

```java
public sealed interface TaxableItem permits PhysicalProduct, DigitalProduct, Subscription {
    <T> T accept(TaxVisitor<T> visitor);
}
public record PhysicalProduct(String name, BigDecimal price, String state) implements TaxableItem {
    public <T> T accept(TaxVisitor<T> visitor) { return visitor.visit(this); }
}
public record DigitalProduct(String name, BigDecimal price) implements TaxableItem {
    public <T> T accept(TaxVisitor<T> visitor) { return visitor.visit(this); }
}
public record Subscription(String name, BigDecimal monthlyPrice) implements TaxableItem {
    public <T> T accept(TaxVisitor<T> visitor) { return visitor.visit(this); }
}

public interface TaxVisitor<T> {
    T visit(PhysicalProduct product);
    T visit(DigitalProduct product);
    T visit(Subscription subscription);
}

public class UsTaxCalculator implements TaxVisitor<BigDecimal> {
    public BigDecimal visit(PhysicalProduct p) { return p.price().multiply(taxRateFor(p.state())); }
    public BigDecimal visit(DigitalProduct p) { return p.price().multiply(DIGITAL_TAX_RATE); }
    public BigDecimal visit(Subscription s) { return s.monthlyPrice().multiply(SUBSCRIPTION_TAX_RATE); }
}
```

**When to use**: Operations vary by type; adding new operations shouldn't modify existing types.
**Modern alternative**: With sealed types and pattern matching (Java 21), switch expressions often replace Visitor:
```java
public BigDecimal calculateTax(TaxableItem item) {
    return switch (item) {
        case PhysicalProduct p -> p.price().multiply(taxRateFor(p.state()));
        case DigitalProduct d -> d.price().multiply(DIGITAL_TAX_RATE);
        case Subscription s -> s.monthlyPrice().multiply(SUBSCRIPTION_TAX_RATE);
    };
}
```

### Interpreter (Behavioral)

**Intent**: Define a grammar and an interpreter for sentences in that language.

```java
public sealed interface Expression permits NumberExpr, AddExpr, MultiplyExpr, VariableExpr {
    BigDecimal evaluate(Map<String, BigDecimal> context);
}
public record NumberExpr(BigDecimal value) implements Expression {
    public BigDecimal evaluate(Map<String, BigDecimal> context) { return value; }
}
public record VariableExpr(String name) implements Expression {
    public BigDecimal evaluate(Map<String, BigDecimal> context) {
        return Objects.requireNonNull(context.get(name), "Undefined variable: " + name);
    }
}
public record AddExpr(Expression left, Expression right) implements Expression {
    public BigDecimal evaluate(Map<String, BigDecimal> context) {
        return left.evaluate(context).add(right.evaluate(context));
    }
}
public record MultiplyExpr(Expression left, Expression right) implements Expression {
    public BigDecimal evaluate(Map<String, BigDecimal> context) {
        return left.evaluate(context).multiply(right.evaluate(context));
    }
}
```

**When to use**: Domain-specific rules engines, formula evaluation, query builders.
**When to avoid**: Complex grammars (use a proper parser library instead). This is the least commonly used GoF pattern.

---

## Complete GoF Pattern Reference

| Category | Pattern | Modern Java Approach |
|----------|---------|---------------------|
| **Creational** | Abstract Factory | Sealed interface + factory method |
| | Builder | Record + nested Builder class |
| | Factory Method | Static factory or `switch` over sealed types |
| | Prototype | `record.withX()` copy methods |
| | Singleton | Spring-managed `@Component` beans |
| **Structural** | Adapter | Implement target interface, delegate to adaptee |
| | Bridge | Interface + implementations, compose with abstraction |
| | Composite | Sealed hierarchy with collection variant |
| | Decorator | `@Primary` + delegation; Spring AOP |
| | Facade | Service class aggregating subsystem calls |
| | Flyweight | `ConcurrentHashMap` cache; Spring singleton beans |
| | Proxy | Spring AOP, `@Transactional`, `@Cacheable` |
| **Behavioral** | Chain of Responsibility | Spring `FilterChain`, `HandlerInterceptor` |
| | Command | Sealed record hierarchy + `switch` handler |
| | Interpreter | Sealed expression tree with `evaluate()` |
| | Iterator | `Stream`, `Iterable`, page iterators |
| | Mediator | `ApplicationEventPublisher`, workflow coordinator |
| | Memento | Record snapshots; event sourcing |
| | Observer | Spring `@EventListener`, `ApplicationEvent` |
| | State | Sealed interface + enum-driven transitions |
| | Strategy | `Function`/`Predicate` lambdas, DI |
| | Template Method | Abstract class with `final` skeleton + abstract steps |
| | Visitor | Pattern matching `switch` over sealed types |

## Anti-Patterns to Avoid

- **Pattern overuse**: Do not apply patterns where a simple method call suffices
- **Singleton abuse**: Use Spring-managed beans instead of manual singletons
- **Deep inheritance for behavior variation**: Use composition or strategy pattern
- **God Factory**: A single factory creating everything -- split by domain
- **Visitor when pattern matching suffices**: Java 21 sealed types + `switch` is cleaner than Visitor in most cases
- **Interpreter for complex grammars**: Use a parser library (ANTLR, JavaCC) instead
