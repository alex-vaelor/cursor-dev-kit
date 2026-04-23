# Refactoring Patterns for Java

## SOLID Principles in Practice

### Single Responsibility Principle (SRP)

```java
// BEFORE: OrderService handles orders, emails, and PDF generation
@Service
public class OrderService {
    public Order createOrder(OrderRequest request) { /* ... */ }
    public void sendConfirmationEmail(Order order) { /* ... */ }
    public byte[] generateInvoicePdf(Order order) { /* ... */ }
}

// AFTER: Each class has one reason to change
@Service
public class OrderService {
    private final OrderRepository orderRepository;
    public Order createOrder(OrderRequest request) { /* ... */ }
}

@Service
public class OrderNotificationService {
    private final EmailSender emailSender;
    public void sendConfirmation(Order order) { /* ... */ }
}

@Service
public class InvoiceService {
    public byte[] generatePdf(Order order) { /* ... */ }
}
```

### Open/Closed Principle (OCP)

```java
// BEFORE: Adding a new discount type requires modifying existing code
public BigDecimal calculateDiscount(Order order) {
    if (order.type() == OrderType.VIP) return order.total().multiply(new BigDecimal("0.20"));
    if (order.type() == OrderType.BULK) return order.total().multiply(new BigDecimal("0.10"));
    return BigDecimal.ZERO;
}

// AFTER: Sealed interface + pattern matching -- add new types without modifying existing code
public sealed interface DiscountStrategy permits VipDiscount, BulkDiscount, NoDiscount {
    BigDecimal calculate(Order order);
}
public record VipDiscount() implements DiscountStrategy {
    public BigDecimal calculate(Order order) { return order.total().multiply(new BigDecimal("0.20")); }
}
public record BulkDiscount() implements DiscountStrategy {
    public BigDecimal calculate(Order order) { return order.total().multiply(new BigDecimal("0.10")); }
}
public record NoDiscount() implements DiscountStrategy {
    public BigDecimal calculate(Order order) { return BigDecimal.ZERO; }
}
```

### Liskov Substitution Principle (LSP)

```java
// BEFORE: Square overrides setWidth/setHeight, breaks Rectangle contract
// AFTER: Use sealed hierarchy where each shape independently computes area
public sealed interface Shape permits Rectangle, Square, Circle {
    double area();
}
public record Rectangle(double width, double height) implements Shape {
    public double area() { return width * height; }
}
public record Square(double side) implements Shape {
    public double area() { return side * side; }
}
public record Circle(double radius) implements Shape {
    public double area() { return Math.PI * radius * radius; }
}
```

### Interface Segregation Principle (ISP)

```java
// BEFORE: Fat interface forces implementors to stub unused methods
public interface UserRepository {
    User findById(Long id);
    List<User> findAll();
    void save(User user);
    void delete(Long id);
    void bulkImport(List<User> users);
    Report generateAuditReport();
}

// AFTER: Segregated interfaces; classes implement only what they need
public interface ReadableUserRepository {
    Optional<User> findById(Long id);
    List<User> findAll();
}
public interface WritableUserRepository {
    User save(User user);
    void deleteById(Long id);
}
public interface BulkUserOperations {
    int bulkImport(List<User> users);
}
```

### Dependency Inversion Principle (DIP)

```java
// BEFORE: High-level module depends on low-level implementation
@Service
public class OrderService {
    private final SmtpEmailClient emailClient = new SmtpEmailClient();
}

// AFTER: Depend on abstraction; inject via constructor
@Service
public class OrderService {
    private final NotificationSender notificationSender;

    public OrderService(NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }
}

public interface NotificationSender {
    void send(Notification notification);
}

@Component
public class SmtpNotificationSender implements NotificationSender {
    public void send(Notification notification) { /* SMTP logic */ }
}
```

## Common Refactoring Techniques

### Extract Method
When a method does too much, extract cohesive blocks into named methods:
```java
// BEFORE
public OrderSummary processOrder(OrderRequest request) {
    // validate (10 lines)
    // calculate totals (15 lines)
    // apply discounts (10 lines)
    // persist (5 lines)
}

// AFTER
public OrderSummary processOrder(OrderRequest request) {
    var validatedOrder = validate(request);
    var totals = calculateTotals(validatedOrder);
    var discountedTotals = applyDiscounts(totals);
    return persist(discountedTotals);
}
```

### Replace Primitive with Record
```java
// BEFORE: primitive obsession
public void createUser(String email, String phone, int age) { }

// AFTER: domain value objects
public record EmailAddress(String value) {
    public EmailAddress {
        if (!value.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$"))
            throw new IllegalArgumentException("Invalid email: " + value);
    }
}
public record PhoneNumber(String value) { /* validation */ }
public record Age(int value) {
    public Age { if (value < 0 || value > 150) throw new IllegalArgumentException("Invalid age"); }
}
public void createUser(EmailAddress email, PhoneNumber phone, Age age) { }
```

### Replace Conditional with Sealed Interface + Pattern Matching
```java
// BEFORE: type-checking if/else chain
public String formatPayment(Payment payment) {
    if (payment instanceof CreditCardPayment cc) {
        return "Card ending in " + cc.lastFour();
    } else if (payment instanceof BankTransfer bt) {
        return "Transfer to " + bt.iban();
    }
    return "Unknown";
}

// AFTER: exhaustive switch over sealed types
public sealed interface Payment permits CreditCardPayment, BankTransfer, CryptoPayment {}
public record CreditCardPayment(String lastFour) implements Payment {}
public record BankTransfer(String iban) implements Payment {}
public record CryptoPayment(String walletAddress) implements Payment {}

public String formatPayment(Payment payment) {
    return switch (payment) {
        case CreditCardPayment cc -> "Card ending in " + cc.lastFour();
        case BankTransfer bt -> "Transfer to " + bt.iban();
        case CryptoPayment cp -> "Crypto wallet " + cp.walletAddress();
    };
}
```

### Replace Mutable DTO with Record
```java
// BEFORE: mutable POJO with getters/setters
public class UserResponse {
    private Long id;
    private String name;
    private String email;
    // getters, setters, equals, hashCode, toString...
}

// AFTER: immutable record
public record UserResponse(Long id, String name, String email) {}
```

## Refactoring Safety Checklist

1. All existing tests pass before starting
2. Code compiles after each atomic change
3. Tests pass after each atomic change
4. Commit after each successful refactoring step
5. No behavior changes mixed with structural changes
6. Coverage did not decrease after refactoring
