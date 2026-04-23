# Common Issues

## N+1 Query Problem

```java
// N+1 queries -- BAD
List<Post> posts = postRepository.findAll();
for (Post post : posts) {
    User author = userRepository.findById(post.getAuthorId()).orElseThrow();
    post.setAuthor(author);
}

// Single query with JOIN FETCH -- GOOD (Spring Data JPA)
@Query("SELECT p FROM Post p JOIN FETCH p.author")
List<Post> findAllWithAuthors();

// Or batch load with Spring Data JDBC
List<Post> posts = postRepository.findAll();
Set<Long> authorIds = posts.stream().map(Post::getAuthorId).collect(Collectors.toSet());
Map<Long, User> authors = userRepository.findAllById(authorIds).stream()
    .collect(Collectors.toMap(User::getId, Function.identity()));
posts.forEach(p -> p.setAuthor(authors.get(p.getAuthorId())));
```

## Missing Error Handling

```java
// No error handling -- BAD
public UserDto getUser(Long id) {
    return restClient.get()
        .uri("/api/users/{id}", id)
        .retrieve()
        .body(UserDto.class);
}

// Proper error handling -- GOOD
public UserDto getUser(Long id) {
    try {
        return restClient.get()
            .uri("/api/users/{id}", id)
            .retrieve()
            .onStatus(HttpStatusCode::is4xxClientError, (req, res) -> {
                throw new UserNotFoundException("User not found: " + id);
            })
            .body(UserDto.class);
    } catch (RestClientException e) {
        log.error("Failed to fetch user id={}", id, e);
        throw new ServiceException("Could not load user", e);
    }
}
```

## Magic Numbers/Strings

```java
// Magic number -- BAD
if (user.getAge() >= 18) { /* ... */ }
scheduler.schedule(task, 86_400_000, TimeUnit.MILLISECONDS);

// Named constant -- GOOD
private static final int MINIMUM_AGE = 18;
private static final Duration RETRY_INTERVAL = Duration.ofDays(1);

if (user.getAge() >= MINIMUM_AGE) { /* ... */ }
scheduler.schedule(task, RETRY_INTERVAL.toMillis(), TimeUnit.MILLISECONDS);
```

## Deep Nesting

```java
// Deep nesting -- BAD
public void process(User user) {
    if (user != null) {
        if (user.isActive()) {
            if (user.hasPermission(Permission.WRITE)) {
                doSomething(user);
            }
        }
    }
}

// Early returns (guard clauses) -- GOOD
public void process(User user) {
    if (user == null || !user.isActive() || !user.hasPermission(Permission.WRITE)) {
        return;
    }
    doSomething(user);
}
```

## God Classes / God Methods

```java
// Does too much -- BAD
public class OrderService {
    public void processOrder(Order order) {
        // validates, checks inventory, processes payment,
        // sends email, updates DB, logs analytics -- all in one method
    }
}

// Single responsibility -- GOOD
public class OrderService {
    private final OrderValidator validator;
    private final InventoryService inventory;
    private final PaymentService payments;
    private final NotificationService notifications;

    public void processOrder(Order order) {
        validator.validate(order);
        inventory.reserve(order);
        payments.charge(order);
        notifications.sendConfirmation(order);
    }
}
```

## Mutable Shared State

```java
// Shared mutable -- BAD
public class AppConfig {
    public static boolean debug = false;
}

// Immutable with record -- GOOD (Java 17+)
public record AppConfig(boolean debug, int maxRetries) {
    public AppConfig {
        if (maxRetries < 0) throw new IllegalArgumentException("maxRetries must be >= 0");
    }
}
```

## Missing Null Handling

```java
// Unsafe access -- BAD
String name = user.getProfile().getName();

// Using Optional -- GOOD
String name = Optional.ofNullable(user)
    .map(User::getProfile)
    .map(Profile::getName)
    .orElse("Unknown");
```

## SQL Injection

```java
// String concatenation -- BAD
String query = "SELECT * FROM users WHERE id = " + userId;
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery(query);

// Parameterized query -- GOOD
PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
stmt.setLong(1, userId);
ResultSet rs = stmt.executeQuery();

// Spring JdbcClient -- GOOD (Spring 6.1+)
User user = jdbcClient.sql("SELECT * FROM users WHERE id = :id")
    .param("id", userId)
    .query(User.class)
    .single();
```

## Checked Exceptions Leaking

```java
// Leaking implementation details -- BAD
public User findUser(Long id) throws SQLException, IOException {
    // callers forced to handle low-level exceptions
}

// Domain exception wrapping -- GOOD
public User findUser(Long id) {
    try {
        return userRepository.findById(id)
            .orElseThrow(() -> new UserNotFoundException("User not found: " + id));
    } catch (DataAccessException e) {
        throw new ServiceException("Failed to find user", e);
    }
}
```

## Blocking Calls in Reactive/Virtual Thread Context

```java
// Blocking in virtual thread carrier -- BAD
Thread.ofVirtual().start(() -> {
    synchronized (lock) {  // pins the carrier thread
        doWork();
    }
});

// ReentrantLock for virtual threads -- GOOD
private final ReentrantLock lock = new ReentrantLock();

Thread.ofVirtual().start(() -> {
    lock.lock();
    try {
        doWork();
    } finally {
        lock.unlock();
    }
});
```

## Quick Reference

| Issue | Impact | Fix |
|-------|--------|-----|
| N+1 queries | Performance | JOIN FETCH or batch load |
| Missing error handling | Reliability | Try/catch + domain exceptions |
| Magic numbers | Maintainability | Named constants |
| Deep nesting | Readability | Guard clauses (early returns) |
| God classes | Testability | Single responsibility, DI |
| Mutable shared state | Thread safety | Records, immutable objects |
| Missing null handling | NullPointerException | Optional, null checks |
| SQL injection | Security | Parameterized queries, JdbcClient |
| Checked exception leaking | Tight coupling | Domain exception wrapping |
| Blocking in virtual threads | Thread pinning | ReentrantLock over synchronized |
