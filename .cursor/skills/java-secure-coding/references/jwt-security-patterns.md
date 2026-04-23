# JWT Security Patterns for Spring Boot

## JWT Structure

```
Header.Payload.Signature
eyJhbG...  .  eyJzdW...  .  SflKxw...
```

| Part | Contains | Example Claims |
|------|----------|---------------|
| **Header** | Algorithm, token type | `{"alg": "RS256", "typ": "JWT"}` |
| **Payload** | Claims (user data) | `sub`, `iss`, `aud`, `exp`, `iat`, `roles` |
| **Signature** | Cryptographic verification | HMAC or RSA/EC signature |

## Signing Algorithms

| Algorithm | Type | Key Management | Recommendation |
|-----------|------|---------------|----------------|
| **HS256** | Symmetric (shared secret) | Same key signs and verifies | Internal services only; never for public APIs |
| **RS256** | Asymmetric (RSA) | Private key signs; public key verifies | Standard for most APIs |
| **ES256** | Asymmetric (ECDSA) | Smaller keys, faster | Preferred for new systems |

**Rule**: Use asymmetric algorithms (RS256 or ES256) for public-facing APIs. The authorization server holds the private key; resource servers only need the public key.

## Spring Security JWT Resource Server

### Configuration
```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: https://auth.example.com/
```

Spring auto-discovers the JWKS endpoint from the issuer.

### Security Filter Chain
```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    return http
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/api/public/**").permitAll()
            .requestMatchers("/api/admin/**").hasRole("ADMIN")
            .anyRequest().authenticated()
        )
        .oauth2ResourceServer(oauth2 -> oauth2
            .jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthConverter()))
        )
        .sessionManagement(session -> session
            .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .csrf(csrf -> csrf.disable())
        .build();
}
```

### Custom JWT Converter (Roles from Claims)
```java
@Bean
public JwtAuthenticationConverter jwtAuthConverter() {
    var authorities = new JwtGrantedAuthoritiesConverter();
    authorities.setAuthoritiesClaimName("roles");
    authorities.setAuthorityPrefix("ROLE_");

    var converter = new JwtAuthenticationConverter();
    converter.setJwtGrantedAuthoritiesConverter(authorities);
    converter.setPrincipalClaimName("sub");
    return converter;
}
```

## Token Validation Checklist

| Validation | How | Spring Boot Default |
|-----------|-----|---------------------|
| **Signature** | Verify against JWKS public key | Automatic |
| **Expiration (`exp`)** | Reject expired tokens | Automatic (clock skew: 60s) |
| **Issuer (`iss`)** | Must match `issuer-uri` | Automatic |
| **Audience (`aud`)** | Must include this service | Configure via `JwtDecoder` |
| **Not Before (`nbf`)** | Token not valid before this time | Automatic |

### Custom Audience Validation
```java
@Bean
public JwtDecoder jwtDecoder() {
    var decoder = JwtDecoders.fromIssuerLocation("https://auth.example.com/");
    var validators = List.of(
        new JwtTimestampValidator(),
        new JwtIssuerValidator("https://auth.example.com/"),
        audienceValidator()
    );
    ((NimbusJwtDecoder) decoder).setJwtValidator(new DelegatingOAuth2TokenValidator<>(validators));
    return decoder;
}

private OAuth2TokenValidator<Jwt> audienceValidator() {
    return new JwtClaimValidator<List<String>>("aud", aud -> aud.contains("my-api"));
}
```

## Refresh Token Rotation

```
Client                     Auth Server               Resource Server
  │                             │                           │
  ├─ Login (credentials) ──────►│                           │
  │◄── Access Token (15m) ──────┤                           │
  │◄── Refresh Token (7d) ──────┤                           │
  │                             │                           │
  ├─ API call (Access Token) ───┼──────────────────────────►│
  │◄── 200 OK ──────────────────┼───────────────────────────┤
  │                             │                           │
  │ (Access Token expired)      │                           │
  ├─ Refresh (Refresh Token) ──►│                           │
  │◄── New Access Token ────────┤                           │
  │◄── New Refresh Token ───────┤  (old refresh token invalidated)
```

- **Access tokens**: Short-lived (5-15 minutes)
- **Refresh tokens**: Longer-lived (hours to days); one-time use
- **Rotation**: Each refresh request issues both new access AND new refresh token; old refresh token is invalidated

## Token Revocation Strategies

| Strategy | Mechanism | Latency | Complexity |
|----------|-----------|---------|------------|
| **Short-lived tokens** | Set `exp` to 5-15 min; no revocation needed | Up to `exp` duration | Low |
| **Token blacklist** | Store revoked token IDs in Redis; check on each request | Real-time | Medium |
| **Token versioning** | Store user's token version in DB; reject older versions | Real-time | Medium |

### Redis Token Blacklist
```java
@Component
public class TokenBlacklistService {
    private final StringRedisTemplate redis;

    public void revoke(String jti, Instant expiration) {
        long ttl = Duration.between(Instant.now(), expiration).getSeconds();
        redis.opsForValue().set("blacklist:" + jti, "revoked", Duration.ofSeconds(ttl));
    }

    public boolean isRevoked(String jti) {
        return Boolean.TRUE.equals(redis.hasKey("blacklist:" + jti));
    }
}
```

## Common JWT Vulnerabilities

| Vulnerability | Risk | Mitigation |
|--------------|------|------------|
| **Algorithm confusion** | Attacker changes `alg` to `none` or symmetric | Explicitly configure allowed algorithms |
| **Weak signing secret** | Brute-force HS256 secret | Use RS256/ES256; if HS256, use >=256-bit secret |
| **Token in URL** | Token logged in server logs, browser history | Use Authorization header, never query params |
| **Missing audience check** | Token for Service A accepted by Service B | Validate `aud` claim |
| **Storing sensitive data** | JWT payload is Base64-encoded, not encrypted | Never put PII, passwords, or secrets in claims |
| **Long-lived tokens** | Extended window for stolen token use | Short-lived access tokens + refresh rotation |
| **Missing issuer validation** | Accept tokens from any issuer | Validate `iss` claim against expected issuer |

## Testing JWT Security

```java
@WebMvcTest(OrderController.class)
class OrderSecurityTest {
    @Autowired private MockMvc mockMvc;

    @Test
    void shouldRejectUnauthenticatedRequest() throws Exception {
        mockMvc.perform(get("/api/v1/orders"))
            .andExpect(status().isUnauthorized());
    }

    @Test
    @WithMockUser(roles = "USER")
    void shouldAllowAuthenticatedUser() throws Exception {
        mockMvc.perform(get("/api/v1/orders"))
            .andExpect(status().isOk());
    }

    @Test
    void shouldRejectExpiredToken() throws Exception {
        var expiredJwt = createJwt(Instant.now().minusSeconds(3600));
        mockMvc.perform(get("/api/v1/orders")
            .header("Authorization", "Bearer " + expiredJwt))
            .andExpect(status().isUnauthorized());
    }
}
```
