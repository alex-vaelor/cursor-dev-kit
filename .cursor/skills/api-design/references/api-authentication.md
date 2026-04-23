# API Authentication Patterns for Spring Boot

## Authentication Strategies

| Strategy | Use Case | Spring Support |
|----------|----------|---------------|
| **JWT (Bearer Token)** | Stateless APIs, microservices | Spring Security + `spring-security-oauth2-resource-server` |
| **OAuth2 + OIDC** | External consumers, SSO, delegated access | Spring Security OAuth2 Login / Resource Server |
| **API Keys** | Service-to-service, third-party integrations | Custom filter + header validation |
| **mTLS** | High-security service-to-service | Spring Boot SSL bundles |

## JWT Authentication (Spring Security)

### Resource Server Configuration
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers("/actuator/health").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt
                    .jwtAuthenticationConverter(jwtAuthenticationConverter())
                )
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .csrf(csrf -> csrf.disable())
            .build();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        var grantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();
        grantedAuthoritiesConverter.setAuthorityPrefix("ROLE_");
        grantedAuthoritiesConverter.setAuthoritiesClaimName("roles");

        var converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(grantedAuthoritiesConverter);
        return converter;
    }
}
```

### Application Configuration
```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: https://auth.example.com/
          # Or explicit JWKS endpoint:
          # jwk-set-uri: https://auth.example.com/.well-known/jwks.json
```

### JWT Validation Checklist
- [ ] Signature verified against issuer's public key (JWKS)
- [ ] `exp` (expiration) claim checked
- [ ] `iss` (issuer) claim matches expected issuer
- [ ] `aud` (audience) claim matches this service
- [ ] Token not reused after revocation (if using token revocation list)

## OAuth2 Authorization Code Flow (with PKCE)

For browser-based clients:
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          keycloak:
            client-id: my-app
            scope: openid,profile,email
            authorization-grant-type: authorization_code
        provider:
          keycloak:
            issuer-uri: https://auth.example.com/realms/my-realm
```

## API Key Authentication

For service-to-service or third-party integrations:

```java
@Component
public class ApiKeyFilter extends OncePerRequestFilter {
    private final ApiKeyService apiKeyService;

    public ApiKeyFilter(ApiKeyService apiKeyService) {
        this.apiKeyService = apiKeyService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain chain) throws ServletException, IOException {
        String apiKey = request.getHeader("X-API-Key");
        if (apiKey != null && apiKeyService.isValid(apiKey)) {
            var auth = new ApiKeyAuthentication(apiKey, apiKeyService.getAuthorities(apiKey));
            SecurityContextHolder.getContext().setAuthentication(auth);
        }
        chain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return request.getRequestURI().startsWith("/api/public/");
    }
}
```

## Method-Level Authorization

```java
@Service
public class OrderService {

    @PreAuthorize("hasRole('USER')")
    public Order createOrder(OrderRequest request) { /* ... */ }

    @PreAuthorize("hasRole('ADMIN') or @orderSecurity.isOwner(#orderId, authentication)")
    public Order getOrder(Long orderId) { /* ... */ }

    @PreAuthorize("hasRole('ADMIN')")
    public void deleteOrder(Long orderId) { /* ... */ }
}

@Component("orderSecurity")
public class OrderSecurityEvaluator {
    private final OrderRepository orderRepository;

    public boolean isOwner(Long orderId, Authentication authentication) {
        return orderRepository.findById(orderId)
            .map(order -> order.userId().equals(authentication.getName()))
            .orElse(false);
    }
}
```

## Security Anti-Patterns

| Anti-Pattern | Risk | Fix |
|-------------|------|-----|
| JWT secret in source code | Token forgery | Use asymmetric keys (RS256) from vault |
| No token expiration | Permanent access if leaked | Short-lived tokens (15 min) + refresh tokens |
| `permitAll()` by default | Endpoints exposed | `anyRequest().authenticated()` as default |
| Trusting client-sent user ID | Privilege escalation | Extract user from JWT, never from request body |
| Logging JWT tokens | Token theft from logs | Never log Authorization header values |
