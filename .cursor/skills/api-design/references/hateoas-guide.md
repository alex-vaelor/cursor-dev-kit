# HATEOAS Guide for Spring Boot

## What Is HATEOAS

Hypermedia As The Engine Of Application State. API responses include links that tell clients what actions are available, making the API self-describing and navigable.

## When to Use HATEOAS

| Use HATEOAS | Skip HATEOAS |
|------------|-------------|
| Public APIs consumed by external developers | Internal microservice-to-microservice APIs |
| APIs where client needs to discover available actions | Simple CRUD with well-known, stable endpoints |
| Workflow-driven APIs (state machine transitions) | High-performance APIs where every byte counts |
| APIs that evolve without breaking clients | Mobile APIs with fixed UI flows |

## Spring HATEOAS Setup

### Dependency
```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-hateoas</artifactId>
</dependency>
```

## Core Concepts

| Class | Purpose |
|-------|---------|
| `EntityModel<T>` | Wraps a single resource with links |
| `CollectionModel<T>` | Wraps a collection of resources with links |
| `PagedModel<T>` | Wraps a paged collection with page metadata + links |
| `Link` | A hypermedia link (rel + href) |
| `WebMvcLinkBuilder` | Type-safe link construction from controller methods |
| `RepresentationModelAssembler` | Reusable conversion from entity to model |

## Implementation

### RepresentationModelAssembler
```java
@Component
public class OrderModelAssembler
    implements RepresentationModelAssembler<OrderResponse, EntityModel<OrderResponse>> {

    @Override
    public EntityModel<OrderResponse> toModel(OrderResponse order) {
        var model = EntityModel.of(order,
            linkTo(methodOn(OrderController.class).getOrder(order.id())).withSelfRel(),
            linkTo(methodOn(OrderController.class).listOrders(Pageable.unpaged())).withRel("orders"));

        if (order.status() == OrderStatus.PENDING) {
            model.add(linkTo(methodOn(OrderController.class).confirmOrder(order.id())).withRel("confirm"));
            model.add(linkTo(methodOn(OrderController.class).cancelOrder(order.id())).withRel("cancel"));
        }
        if (order.status() == OrderStatus.CONFIRMED) {
            model.add(linkTo(methodOn(OrderController.class).shipOrder(order.id())).withRel("ship"));
        }

        return model;
    }
}
```

### Controller
```java
@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {
    private final OrderService orderService;
    private final OrderModelAssembler assembler;
    private final PagedResourcesAssembler<OrderResponse> pagedAssembler;

    @GetMapping("/{id}")
    public EntityModel<OrderResponse> getOrder(@PathVariable Long id) {
        var order = orderService.findById(id);
        return assembler.toModel(order);
    }

    @GetMapping
    public PagedModel<EntityModel<OrderResponse>> listOrders(Pageable pageable) {
        var page = orderService.findAll(pageable);
        return pagedAssembler.toModel(page, assembler);
    }

    @PostMapping("/{id}/confirm")
    public EntityModel<OrderResponse> confirmOrder(@PathVariable Long id) {
        var order = orderService.confirm(id);
        return assembler.toModel(order);
    }
}
```

### HAL Response
```json
{
  "id": 1,
  "description": "Laptop order",
  "status": "PENDING",
  "total": 1299.99,
  "_links": {
    "self": { "href": "/api/v1/orders/1" },
    "orders": { "href": "/api/v1/orders" },
    "confirm": { "href": "/api/v1/orders/1/confirm" },
    "cancel": { "href": "/api/v1/orders/1/cancel" }
  }
}
```

After confirmation:
```json
{
  "id": 1,
  "status": "CONFIRMED",
  "_links": {
    "self": { "href": "/api/v1/orders/1" },
    "orders": { "href": "/api/v1/orders" },
    "ship": { "href": "/api/v1/orders/1/ship" }
  }
}
```

## Paginated Collection
```json
{
  "_embedded": {
    "orderResponseList": [
      { "id": 1, "description": "Order 1", "_links": { "self": { "href": "/api/v1/orders/1" } } },
      { "id": 2, "description": "Order 2", "_links": { "self": { "href": "/api/v1/orders/2" } } }
    ]
  },
  "_links": {
    "self": { "href": "/api/v1/orders?page=0&size=20" },
    "next": { "href": "/api/v1/orders?page=1&size=20" },
    "last": { "href": "/api/v1/orders?page=4&size=20" }
  },
  "page": {
    "size": 20,
    "totalElements": 95,
    "totalPages": 5,
    "number": 0
  }
}
```

## Testing HATEOAS
```java
@WebMvcTest(OrderController.class)
class OrderControllerHateoasTest {
    @Autowired private MockMvc mockMvc;
    @MockBean private OrderService orderService;

    @Test
    void shouldIncludeConfirmLinkForPendingOrder() throws Exception {
        given(orderService.findById(1L)).willReturn(
            new OrderResponse(1L, "Test", BigDecimal.TEN, OrderStatus.PENDING));

        mockMvc.perform(get("/api/v1/orders/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$._links.self.href").value(endsWith("/orders/1")))
            .andExpect(jsonPath("$._links.confirm.href").value(endsWith("/orders/1/confirm")))
            .andExpect(jsonPath("$._links.cancel.href").value(endsWith("/orders/1/cancel")));
    }

    @Test
    void shouldNotIncludeConfirmLinkForConfirmedOrder() throws Exception {
        given(orderService.findById(1L)).willReturn(
            new OrderResponse(1L, "Test", BigDecimal.TEN, OrderStatus.CONFIRMED));

        mockMvc.perform(get("/api/v1/orders/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$._links.confirm").doesNotExist())
            .andExpect(jsonPath("$._links.ship.href").value(endsWith("/orders/1/ship")));
    }
}
```
