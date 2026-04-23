# JPA Validation Patterns

## Validation Layers

| Layer | Purpose | Tools |
|-------|---------|-------|
| **API boundary** | Validate request DTOs before processing | `@Valid`, Jakarta Bean Validation annotations |
| **Entity** | Guard database invariants as safety net | JPA `@Column` constraints, Bean Validation on fields |
| **Service** | Enforce business rules | Programmatic checks, custom exceptions |

## Entity-Level Validation

### Column Constraints + Bean Validation
```java
@Entity
@Table(name = "products")
public class Product {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    @NotBlank @Size(max = 200)
    private String name;

    @Column(nullable = false, precision = 19, scale = 2)
    @NotNull @Positive
    private BigDecimal price;

    @Column(nullable = false, unique = true, length = 50)
    @NotBlank @Size(max = 50)
    @Pattern(regexp = "^[A-Z0-9-]+$", message = "SKU must be uppercase alphanumeric with dashes")
    private String sku;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @NotNull
    private ProductStatus status;
}
```

### When Entity Validation Fires
- **Pre-persist / pre-update**: Hibernate triggers Bean Validation automatically before flushing
- Produces `ConstraintViolationException` if validation fails
- This is a safety net, NOT primary validation (validate on DTOs first)

## DTO Validation at API Boundary

```java
public record CreateProductRequest(
    @NotBlank @Size(max = 200)
    String name,

    @NotNull @Positive
    BigDecimal price,

    @NotBlank @Pattern(regexp = "^[A-Z0-9-]+$")
    String sku,

    @Size(max = 2000)
    String description
) {}

@PostMapping("/products")
public ResponseEntity<ProductResponse> create(@Valid @RequestBody CreateProductRequest request) {
    // Only reaches here if validation passes
}
```

## Cross-Field Validation

### Class-Level Constraint
```java
@Target(TYPE)
@Retention(RUNTIME)
@Constraint(validatedBy = PriceRangeValidator.class)
public @interface ValidPriceRange {
    String message() default "Max price must be greater than min price";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

@ValidPriceRange
public record PriceFilterRequest(
    @PositiveOrZero BigDecimal minPrice,
    @PositiveOrZero BigDecimal maxPrice
) {}

public class PriceRangeValidator implements ConstraintValidator<ValidPriceRange, PriceFilterRequest> {
    @Override
    public boolean isValid(PriceFilterRequest value, ConstraintValidatorContext ctx) {
        if (value.minPrice() == null || value.maxPrice() == null) return true;
        return value.maxPrice().compareTo(value.minPrice()) > 0;
    }
}
```

## Validation Groups

```java
public interface OnCreate {}
public interface OnUpdate {}

public record ProductRequest(
    @Null(groups = OnCreate.class, message = "ID must not be set on create")
    @NotNull(groups = OnUpdate.class, message = "ID required on update")
    Long id,

    @NotBlank(groups = {OnCreate.class, OnUpdate.class})
    String name,

    @NotNull(groups = OnCreate.class)
    BigDecimal price
) {}

@PostMapping
public ResponseEntity<?> create(@Validated(OnCreate.class) @RequestBody ProductRequest req) {}

@PutMapping("/{id}")
public ResponseEntity<?> update(@Validated(OnUpdate.class) @RequestBody ProductRequest req) {}
```

## Custom Validators

### Unique Constraint Validator
```java
@Target(FIELD)
@Retention(RUNTIME)
@Constraint(validatedBy = UniqueSkuValidator.class)
public @interface UniqueSku {
    String message() default "SKU already exists";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

@Component
public class UniqueSkuValidator implements ConstraintValidator<UniqueSku, String> {
    private final ProductRepository repository;

    @Override
    public boolean isValid(String sku, ConstraintValidatorContext ctx) {
        if (sku == null) return true;
        return !repository.existsBySku(sku);
    }
}
```

## Hibernate Validator Extensions

Beyond Jakarta Bean Validation standard:

| Annotation | Purpose |
|-----------|---------|
| `@URL` | Validate URL format |
| `@CreditCardNumber` | Luhn check |
| `@ISBN` | ISBN format |
| `@Range(min, max)` | Numeric range |
| `@Length(min, max)` | String length (alternative to `@Size`) |
| `@UniqueElements` | Collection has no duplicates |
| `@CodePointLength` | Unicode-aware length |

## Error Handling for Validation

```java
@RestControllerAdvice
public class ValidationExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleDtoValidation(MethodArgumentNotValidException ex) {
        var problem = ProblemDetail.forStatus(HttpStatus.BAD_REQUEST);
        problem.setTitle("Validation Failed");
        problem.setProperty("errors", ex.getFieldErrors().stream()
            .map(fe -> Map.of("field", fe.getField(), "message", fe.getDefaultMessage()))
            .toList());
        return problem;
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ProblemDetail handleEntityValidation(ConstraintViolationException ex) {
        var problem = ProblemDetail.forStatus(HttpStatus.BAD_REQUEST);
        problem.setTitle("Constraint Violation");
        problem.setProperty("violations", ex.getConstraintViolations().stream()
            .map(v -> Map.of("path", v.getPropertyPath().toString(), "message", v.getMessage()))
            .toList());
        return problem;
    }
}
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Validation only on entities | Late failure, poor error messages | Validate on DTOs at API boundary |
| Business rules as annotations | `@CustomRule` mixing concerns | Programmatic checks in service layer |
| Skipping `@Valid` on nested objects | Nested DTOs not validated | Add `@Valid` on collection/nested fields |
| Same DTO for create and update | Different validation needs | Separate DTOs or validation groups |
