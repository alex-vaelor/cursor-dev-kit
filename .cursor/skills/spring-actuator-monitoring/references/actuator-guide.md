# Actuator Configuration Guide

## Minimal Production Configuration

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health, info, metrics, prometheus
      base-path: /actuator
  endpoint:
    health:
      show-details: when-authorized
      probes:
        enabled: true
      group:
        liveness:
          include: livenessState
        readiness:
          include: readinessState, db, redis, diskSpace
  info:
    env:
      enabled: true
  prometheus:
    metrics:
      export:
        enabled: true
```

## Endpoint Security

```java
@Configuration
public class ActuatorSecurityConfig {

    @Bean
    @Order(1)
    public SecurityFilterChain actuatorSecurity(HttpSecurity http) throws Exception {
        return http
            .securityMatcher("/actuator/**")
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/health/**").permitAll()
                .requestMatchers("/actuator/health/liveness").permitAll()
                .requestMatchers("/actuator/health/readiness").permitAll()
                .requestMatchers("/actuator/info").permitAll()
                .requestMatchers("/actuator/prometheus").permitAll()
                .anyRequest().hasRole("ACTUATOR_ADMIN")
            )
            .httpBasic(Customizer.withDefaults())
            .build();
    }
}
```

## Custom Health Indicators

### External Service Health
```java
@Component
public class PaymentGatewayHealthIndicator implements HealthIndicator {
    private final PaymentGatewayClient client;
    private final CircuitBreaker circuitBreaker;

    @Override
    public Health health() {
        if (circuitBreaker.getState() == CircuitBreaker.State.OPEN) {
            return Health.down()
                .withDetail("gateway", "circuit breaker open")
                .build();
        }
        try {
            var response = client.healthCheck();
            return Health.up()
                .withDetail("gateway", "reachable")
                .withDetail("latency", response.latencyMs() + "ms")
                .build();
        } catch (Exception e) {
            return Health.down()
                .withDetail("gateway", "unreachable")
                .withDetail("error", e.getMessage())
                .build();
        }
    }
}
```

### Composite Health for Readiness
```java
@Component
public class ApplicationReadinessIndicator implements HealthIndicator {
    private final CacheManager cacheManager;
    private final DataSource dataSource;

    @Override
    public Health health() {
        var builder = Health.up();
        try (var conn = dataSource.getConnection()) {
            builder.withDetail("database", "connected");
        } catch (SQLException e) {
            return Health.down().withDetail("database", e.getMessage()).build();
        }
        if (cacheManager.getCacheNames().isEmpty()) {
            builder.withDetail("cache", "no caches initialized");
        } else {
            builder.withDetail("cache", "ready");
        }
        return builder.build();
    }
}
```

## Kubernetes Probe Configuration

### Deployment Manifest
```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
        - name: app
          livenessProbe:
            httpGet:
              path: /actuator/health/liveness
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 5
            failureThreshold: 3
          startupProbe:
            httpGet:
              path: /actuator/health/liveness
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
            failureThreshold: 30
```

### Probe Design Rules
| Probe | What It Checks | Failure Action |
|-------|---------------|----------------|
| **Startup** | App started successfully | Keep waiting (prevents premature kill) |
| **Liveness** | JVM alive, not deadlocked | Restart container |
| **Readiness** | Can serve traffic (DB, cache connected) | Remove from load balancer |

**Important**: Liveness probes should NOT check external dependencies. If the DB is down, restarting the app won't fix it.

## Info Endpoint
```yaml
info:
  app:
    name: "@project.name@"
    version: "@project.version@"
    description: "@project.description@"
    java-version: ${java.version}
    spring-boot-version: "@spring-boot.version@"
  build:
    time: "@maven.build.timestamp@"
  git:
    branch: ${GIT_BRANCH:unknown}
    commit: ${GIT_COMMIT:unknown}
```

## Management Port Separation
```yaml
management:
  server:
    port: 9090
    ssl:
      enabled: false
```
Separating the management port keeps Actuator traffic off the application port, simplifying firewall rules and load balancer configuration.
