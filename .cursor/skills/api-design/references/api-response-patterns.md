# API Response Patterns for Spring Boot

## Standard Response Structure

### Success Responses

```java
// Single resource
@GetMapping("/orders/{id}")
public ResponseEntity<OrderResponse> getOrder(@PathVariable Long id) {
    return orderService.findById(id)
        .map(ResponseEntity::ok)
        .orElseGet(() -> ResponseEntity.notFound().build());
}

// Collection with pagination
@GetMapping("/orders")
public ResponseEntity<Page<OrderResponse>> listOrders(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "20") int size,
        @RequestParam(defaultValue = "createdAt,desc") String sort) {
    var pageable = PageRequest.of(page, size, Sort.by(parseSortOrders(sort)));
    return ResponseEntity.ok(orderService.findAll(pageable));
}

// Creation
@PostMapping("/orders")
public ResponseEntity<OrderResponse> createOrder(@Valid @RequestBody CreateOrderRequest request) {
    var order = orderService.create(request);
    var location = URI.create("/api/v1/orders/" + order.id());
    return ResponseEntity.created(location).body(order);
}

// No content (delete, update with no body)
@DeleteMapping("/orders/{id}")
public ResponseEntity<Void> deleteOrder(@PathVariable Long id) {
    orderService.delete(id);
    return ResponseEntity.noContent().build();
}
```

### HTTP Status Code Guide

| Scenario | Status Code | When |
|----------|-------------|------|
| Success (GET, PUT, PATCH) | 200 OK | Resource returned or updated |
| Success (POST) | 201 Created | Resource created; include `Location` header |
| Success (DELETE) | 204 No Content | Resource deleted |
| Accepted | 202 Accepted | Async operation started |
| Bad request | 400 Bad Request | Validation failure |
| Unauthorized | 401 Unauthorized | Missing or invalid credentials |
| Forbidden | 403 Forbidden | Authenticated but not authorized |
| Not found | 404 Not Found | Resource does not exist |
| Conflict | 409 Conflict | Business rule violation (duplicate, state conflict) |
| Unprocessable | 422 Unprocessable Entity | Semantically invalid (valid JSON, bad business logic) |
| Rate limited | 429 Too Many Requests | Rate limit exceeded |
| Server error | 500 Internal Server Error | Unexpected error |

## Error Responses (RFC 9457 Problem Detail)

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleValidation(MethodArgumentNotValidException ex) {
        var problem = ProblemDetail.forStatusAndDetail(
            HttpStatus.BAD_REQUEST, "Validation failed");
        problem.setType(URI.create("https://api.example.com/errors/validation"));
        problem.setTitle("Validation Error");

        var errors = ex.getBindingResult().getFieldErrors().stream()
            .map(fe -> Map.of("field", fe.getField(), "message", fe.getDefaultMessage()))
            .toList();
        problem.setProperty("errors", errors);

        return problem;
    }

    @ExceptionHandler(OrderNotFoundException.class)
    public ProblemDetail handleNotFound(OrderNotFoundException ex) {
        var problem = ProblemDetail.forStatusAndDetail(
            HttpStatus.NOT_FOUND, ex.getMessage());
        problem.setType(URI.create("https://api.example.com/errors/not-found"));
        problem.setTitle("Resource Not Found");
        return problem;
    }

    @ExceptionHandler(BusinessRuleViolationException.class)
    public ProblemDetail handleConflict(BusinessRuleViolationException ex) {
        var problem = ProblemDetail.forStatusAndDetail(
            HttpStatus.CONFLICT, ex.getMessage());
        problem.setType(URI.create("https://api.example.com/errors/business-rule"));
        problem.setTitle("Business Rule Violation");
        return problem;
    }

    @ExceptionHandler(Exception.class)
    public ProblemDetail handleUnexpected(Exception ex) {
        log.error("Unhandled exception", ex);
        var problem = ProblemDetail.forStatusAndDetail(
            HttpStatus.INTERNAL_SERVER_ERROR, "An unexpected error occurred");
        problem.setType(URI.create("https://api.example.com/errors/internal"));
        problem.setTitle("Internal Server Error");
        return problem;
    }
}
```

## Pagination Response Patterns

### Spring Data Page Response
```json
{
  "content": [
    {"id": 1, "description": "Order 1"},
    {"id": 2, "description": "Order 2"}
  ],
  "page": {
    "number": 0,
    "size": 20,
    "totalElements": 42,
    "totalPages": 3
  }
}
```

### Cursor-Based Pagination (for large datasets)
```java
public record CursorPage<T>(
    List<T> items,
    String nextCursor,
    boolean hasMore
) {}

@GetMapping("/events")
public ResponseEntity<CursorPage<EventResponse>> listEvents(
        @RequestParam(required = false) String cursor,
        @RequestParam(defaultValue = "50") int limit) {
    return ResponseEntity.ok(eventService.findAfterCursor(cursor, limit));
}
```

## Response DTOs as Records

```java
public record OrderResponse(
    Long id,
    String description,
    BigDecimal total,
    OrderStatus status,
    Instant createdAt
) {
    public static OrderResponse from(Order order) {
        return new OrderResponse(
            order.getId(),
            order.getDescription(),
            order.getTotal(),
            order.getStatus(),
            order.getCreatedAt()
        );
    }
}
```

## Content Negotiation

```java
@GetMapping(value = "/reports/{id}",
    produces = {MediaType.APPLICATION_JSON_VALUE, "text/csv"})
public ResponseEntity<?> getReport(@PathVariable Long id, HttpServletRequest request) {
    var report = reportService.findById(id);
    String accept = request.getHeader("Accept");

    if ("text/csv".equals(accept)) {
        return ResponseEntity.ok()
            .contentType(MediaType.parseMediaType("text/csv"))
            .body(report.toCsv());
    }
    return ResponseEntity.ok(report);
}
```

## Response Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Returning entity directly | Exposes internal model, lazy-loading issues | Use record DTOs with `from()` factory |
| Generic `Map<String, Object>` responses | No type safety, inconsistent format | Use typed record DTOs |
| Error in 200 response body | Confuses clients, breaks REST semantics | Use proper HTTP status codes |
| Stack traces in error responses | Security risk, information disclosure | Use RFC 9457 ProblemDetail; log internally |
| No pagination for collections | Memory issues, slow responses | Always paginate unbounded collections |
