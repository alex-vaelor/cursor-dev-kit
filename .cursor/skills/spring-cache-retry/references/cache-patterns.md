# Cache Patterns for Spring Boot

## Caching Strategies

| Strategy | How It Works | Use Case |
|----------|-------------|----------|
| **Cache-aside** | App checks cache; on miss, loads from DB and stores | Most common; full control over cache population |
| **Read-through** | Cache itself loads from DB on miss | When cache framework supports it (e.g., JCache/Caffeine loader) |
| **Write-through** | Write to cache and DB simultaneously | Strong consistency requirement |
| **Write-behind** | Write to cache immediately; async write to DB | High write throughput, eventual consistency acceptable |

Spring `@Cacheable` implements **cache-aside** by default.

## Spring Cache Abstraction

### Enable Caching
```java
@Configuration
@EnableCaching
public class CacheConfig { }
```

### Basic Usage
```java
@Service
public class ProductService {
    private final ProductRepository repository;

    @Cacheable(value = "products", key = "#id")
    public Product findById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new ProductNotFoundException(id));
    }

    @Cacheable(value = "productSearch", key = "#category + '-' + #pageable.pageNumber")
    @Transactional(readOnly = true)
    public Page<Product> findByCategory(String category, Pageable pageable) {
        return repository.findByCategory(category, pageable);
    }

    @CacheEvict(value = "products", key = "#product.id")
    public Product update(Product product) {
        return repository.save(product);
    }

    @CacheEvict(value = {"products", "productSearch"}, allEntries = true)
    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    @CachePut(value = "products", key = "#result.id")
    public Product create(CreateProductRequest request) {
        return repository.save(new Product(request));
    }
}
```

### Conditional Caching
```java
@Cacheable(value = "products", key = "#id",
    unless = "#result == null",
    condition = "#id > 0")
public Product findById(Long id) { }
```

## Backend Configuration

### ConcurrentMapCacheManager (Local, Dev/Test)
```java
@Bean
@Profile("dev")
public CacheManager cacheManager() {
    return new ConcurrentMapCacheManager("products", "productSearch");
}
```

### Caffeine (Local, Production-Grade)
```xml
<dependency>
  <groupId>com.github.ben-manes.caffeine</groupId>
  <artifactId>caffeine</artifactId>
</dependency>
```
```java
@Bean
public CacheManager cacheManager() {
    var caffeine = Caffeine.newBuilder()
        .maximumSize(10_000)
        .expireAfterWrite(Duration.ofMinutes(30))
        .recordStats();

    return new CaffeineCacheManager("products", "productSearch") {{
        setCaffeine(caffeine);
    }};
}
```

### Redis (Distributed, Multi-Instance)
```java
@Bean
public RedisCacheManager cacheManager(RedisConnectionFactory factory) {
    var defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
        .entryTtl(Duration.ofMinutes(30))
        .disableCachingNullValues()
        .serializeKeysWith(SerializationPair.fromSerializer(new StringRedisSerializer()))
        .serializeValuesWith(SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer()));

    var configs = Map.of(
        "products", RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofHours(1)),
        "productSearch", RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofMinutes(10))
    );

    return RedisCacheManager.builder(factory)
        .cacheDefaults(defaultConfig)
        .withInitialCacheConfigurations(configs)
        .transactionAware()
        .build();
}
```

## Cache Key Design Best Practices

| Practice | Example |
|----------|---------|
| Explicit keys | `key = "#userId + '-' + #page"` |
| Prefix by entity | Cache name = entity type (`"products"`, `"orders"`) |
| Include all discriminators | All params that change the result |
| Avoid complex objects as keys | Use IDs or string representations |

## Cache Eviction Patterns

| Scenario | Approach |
|----------|----------|
| Single entity update | `@CacheEvict(key = "#entity.id")` |
| Bulk data change | `@CacheEvict(allEntries = true)` |
| Related caches | `@Caching(evict = {@CacheEvict("a"), @CacheEvict("b")})` |
| Scheduled cleanup | `@Scheduled` + `cacheManager.getCache("x").clear()` |

## Testing Cache Behavior
```java
@SpringBootTest
class ProductServiceCacheTest {
    @Autowired private ProductService productService;
    @MockBean private ProductRepository repository;

    @Test
    void shouldReturnCachedResultOnSecondCall() {
        given(repository.findById(1L)).willReturn(Optional.of(testProduct()));

        productService.findById(1L);
        productService.findById(1L);

        verify(repository, times(1)).findById(1L);
    }

    @Test
    void shouldEvictCacheOnUpdate() {
        given(repository.findById(1L)).willReturn(Optional.of(testProduct()));
        productService.findById(1L);

        productService.update(updatedProduct());
        productService.findById(1L);

        verify(repository, times(2)).findById(1L);
    }
}
```

## Cache Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| No TTL | Memory exhaustion, stale data forever | Always set TTL per cache |
| Caching null values | Cache fills with nulls | `unless = "#result == null"` or `disableCachingNullValues()` |
| Self-invocation | `this.method()` bypasses proxy, no caching | Inject self or restructure |
| Cache key collision | Different methods share same key | Use distinct cache names |
| No eviction on write | Stale data served after updates | `@CacheEvict` on all mutation paths |
