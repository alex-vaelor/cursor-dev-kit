# GraphQL Implementation Guide for Spring Boot

## Project Setup

### Dependencies
```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-graphql</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<!-- Testing -->
<dependency>
  <groupId>org.springframework.graphql</groupId>
  <artifactId>spring-graphql-test</artifactId>
  <scope>test</scope>
</dependency>
```

### Configuration
```yaml
spring:
  graphql:
    graphiql:
      enabled: ${GRAPHIQL_ENABLED:false}
    schema:
      printer:
        enabled: ${SCHEMA_PRINTER_ENABLED:false}
      locations: classpath:graphql/
    cors:
      allowed-origins: ${CORS_ORIGINS:http://localhost:3000}
```

## Schema Design

### File Organization
```
src/main/resources/graphql/
├── schema.graphqls       # Root Query, Mutation, Subscription types
├── order.graphqls        # Order type, inputs, enums
├── product.graphqls      # Product type
└── common.graphqls       # Shared types (PageInfo, scalars)
```

### Schema Best Practices
```graphql
type Query {
    orderById(id: ID!): Order
    orders(filter: OrderFilter, page: PageInput): OrderConnection!
}

type Mutation {
    createOrder(input: CreateOrderInput!): CreateOrderPayload!
    cancelOrder(id: ID!, reason: String): CancelOrderPayload!
}

type Order {
    id: ID!
    description: String!
    total: BigDecimal!
    status: OrderStatus!
    items: [OrderItem!]!
    customer: Customer!
    createdAt: DateTime!
}

input CreateOrderInput {
    items: [OrderItemInput!]!
    shippingAddress: AddressInput!
}

type CreateOrderPayload {
    order: Order
    errors: [UserError!]
}

type UserError {
    field: String
    message: String!
}

input PageInput {
    page: Int = 0
    size: Int = 20
}

type OrderConnection {
    content: [Order!]!
    pageInfo: PageInfo!
}

type PageInfo {
    totalElements: Int!
    totalPages: Int!
    hasNext: Boolean!
}

scalar BigDecimal
scalar DateTime
```

### Naming Conventions
- Types: PascalCase (`Order`, `OrderItem`)
- Fields: camelCase (`createdAt`, `shippingAddress`)
- Enums: UPPER_SNAKE_CASE values (`PENDING`, `CONFIRMED`)
- Inputs: `*Input` suffix (`CreateOrderInput`)
- Mutation payloads: `*Payload` suffix (`CreateOrderPayload`)

## Controller Implementation

### Query Mappings
```java
@Controller
public class OrderController {
    private final OrderService orderService;

    @QueryMapping
    public Optional<Order> orderById(@Argument Long id) {
        return orderService.findById(id);
    }

    @QueryMapping
    public OrderConnection orders(@Argument OrderFilter filter, @Argument PageInput page) {
        var pageable = PageRequest.of(
            page != null ? page.page() : 0,
            page != null ? page.size() : 20
        );
        return OrderConnection.from(orderService.findAll(filter, pageable));
    }
}
```

### Mutation Mappings
```java
@Controller
public class OrderMutationController {
    private final OrderService orderService;

    @MutationMapping
    public CreateOrderPayload createOrder(@Argument @Valid CreateOrderInput input) {
        try {
            var order = orderService.create(input);
            return CreateOrderPayload.success(order);
        } catch (BusinessValidationException e) {
            return CreateOrderPayload.withErrors(e.getErrors());
        }
    }
}
```

## N+1 Prevention

### @BatchMapping (Recommended)
```java
@Controller
public class OrderRelationController {

    private final CustomerService customerService;
    private final OrderItemService itemService;

    @BatchMapping(typeName = "Order")
    public Map<Order, Customer> customer(List<Order> orders) {
        var ids = orders.stream().map(Order::customerId).distinct().toList();
        var customersById = customerService.findByIds(ids).stream()
            .collect(Collectors.toMap(Customer::id, Function.identity()));
        return orders.stream().collect(Collectors.toMap(
            o -> o,
            o -> customersById.get(o.customerId())
        ));
    }

    @BatchMapping(typeName = "Order")
    public Map<Order, List<OrderItem>> items(List<Order> orders) {
        var ids = orders.stream().map(Order::id).toList();
        var itemsByOrderId = itemService.findByOrderIds(ids).stream()
            .collect(Collectors.groupingBy(OrderItem::orderId));
        return orders.stream().collect(Collectors.toMap(
            o -> o,
            o -> itemsByOrderId.getOrDefault(o.id(), List.of())
        ));
    }
}
```

### DataLoader (For Complex Cases)
```java
@Controller
public class OrderController {

    @SchemaMapping(typeName = "Order", field = "customer")
    public CompletableFuture<Customer> customer(Order order, DataLoader<Long, Customer> customerLoader) {
        return customerLoader.load(order.customerId());
    }
}

@Configuration
public class DataLoaderConfig {
    @Bean
    public BatchLoaderRegistry batchLoaderRegistry(CustomerService customerService) {
        return registry -> registry.forTypePair(Long.class, Customer.class)
            .registerMappedBatchLoader((ids, env) ->
                Mono.fromSupplier(() -> customerService.findByIds(ids).stream()
                    .collect(Collectors.toMap(Customer::id, Function.identity()))));
    }
}
```

## Security

```java
@Controller
public class SecuredGraphQlController {

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public List<Order> myOrders(Authentication auth) {
        return orderService.findByUserId(auth.getName());
    }

    @MutationMapping
    @PreAuthorize("hasRole('ADMIN')")
    public boolean deleteOrder(@Argument Long id) {
        orderService.delete(id);
        return true;
    }
}
```

## Error Handling

```java
@ControllerAdvice
public class GraphQlErrorHandler {

    @GraphQlExceptionHandler
    public GraphQLError handleNotFound(ResourceNotFoundException ex) {
        return GraphQLError.newError()
            .errorType(ErrorType.NOT_FOUND)
            .message(ex.getMessage())
            .build();
    }

    @GraphQlExceptionHandler
    public GraphQLError handleAccessDenied(AccessDeniedException ex) {
        return GraphQLError.newError()
            .errorType(ErrorType.FORBIDDEN)
            .message("Access denied")
            .build();
    }
}
```

## Testing

### Unit Test with @GraphQlTest
```java
@GraphQlTest(OrderController.class)
class OrderControllerTest {
    @Autowired private GraphQlTester tester;
    @MockBean private OrderService orderService;

    @Test
    void shouldReturnOrderById() {
        given(orderService.findById(1L)).willReturn(Optional.of(
            new Order(1L, "Test Order", BigDecimal.TEN, OrderStatus.CONFIRMED)));

        tester.documentName("orderById")
            .variable("id", 1)
            .execute()
            .path("orderById.description").entity(String.class).isEqualTo("Test Order")
            .path("orderById.status").entity(String.class).isEqualTo("CONFIRMED");
    }

    @Test
    void shouldReturnNullForMissingOrder() {
        given(orderService.findById(999L)).willReturn(Optional.empty());

        tester.documentName("orderById")
            .variable("id", 999)
            .execute()
            .path("orderById").valueIsNull();
    }
}
```

### Test Documents
Place in `src/test/resources/graphql-test/`:
```graphql
# orderById.graphql
query orderById($id: ID!) {
    orderById(id: $id) {
        id
        description
        status
    }
}
```

### Integration Test
```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
class OrderGraphQlIntegrationTest {
    @Autowired private HttpGraphQlTester tester;

    @Test
    void shouldCreateOrder() {
        tester.documentName("createOrder")
            .variable("input", Map.of("items", List.of(
                Map.of("productId", 1, "quantity", 2))))
            .execute()
            .path("createOrder.order.id").hasValue();
    }
}
```
