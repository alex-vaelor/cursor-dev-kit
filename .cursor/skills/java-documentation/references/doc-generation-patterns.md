# Documentation Generation Patterns for Java

## Javadoc Generation

### Maven Javadoc Plugin Configuration
```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-javadoc-plugin</artifactId>
  <version>3.10.0</version>
  <configuration>
    <show>public</show>
    <nohelp>true</nohelp>
    <failOnWarnings>true</failOnWarnings>
    <additionalOptions>-Xdoclint:all</additionalOptions>
    <links>
      <link>https://docs.oracle.com/en/java/javase/21/docs/api/</link>
      <link>https://docs.spring.io/spring-framework/docs/current/javadoc-api/</link>
    </links>
  </configuration>
  <executions>
    <execution>
      <id>generate-javadoc</id>
      <phase>package</phase>
      <goals><goal>jar</goal></goals>
    </execution>
  </executions>
</plugin>
```

### Command
```bash
./mvnw javadoc:javadoc          # Generate HTML docs
./mvnw javadoc:jar              # Generate Javadoc JAR for publishing
./mvnw javadoc:test-javadoc     # Generate test source Javadoc
```

### Output
- HTML: `target/site/apidocs/`
- JAR: `target/${artifactId}-${version}-javadoc.jar`

## OpenAPI Documentation Generation

### SpringDoc OpenAPI (for Spring Boot)
```xml
<dependency>
  <groupId>org.springdoc</groupId>
  <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
  <version>2.6.0</version>
</dependency>
```

### Configuration
```yaml
# application.yml
springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
    operations-sorter: method
    tags-sorter: alpha
  show-actuator: false
  default-produces-media-type: application/json
```

### Annotating Controllers
```java
@RestController
@RequestMapping("/api/v1/orders")
@Tag(name = "Orders", description = "Order management operations")
public class OrderController {

    @Operation(
        summary = "Create a new order",
        description = "Creates an order and returns the created resource with a 201 status.",
        responses = {
            @ApiResponse(responseCode = "201", description = "Order created",
                content = @Content(schema = @Schema(implementation = OrderResponse.class))),
            @ApiResponse(responseCode = "400", description = "Invalid request",
                content = @Content(schema = @Schema(implementation = ProblemDetail.class))),
            @ApiResponse(responseCode = "409", description = "Duplicate order",
                content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
        }
    )
    @PostMapping
    public ResponseEntity<OrderResponse> createOrder(
            @Valid @RequestBody OrderRequest request) {
        // ...
    }
}
```

### Exporting OpenAPI Spec for CI
```bash
# Download spec during build
curl -s http://localhost:8080/v3/api-docs > openapi.json

# Or use Maven plugin to generate at build time
./mvnw springdoc-openapi:generate
```

## Site Generation

### Maven Site Plugin
```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-site-plugin</artifactId>
  <version>4.0.0-M16</version>
</plugin>
```

### Reporting Configuration
```xml
<reporting>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-javadoc-plugin</artifactId>
    </plugin>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-report-plugin</artifactId>
    </plugin>
    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
    </plugin>
  </plugins>
</reporting>
```

```bash
./mvnw site
# Output: target/site/index.html
```

## Documentation Quality Checklist

### API Documentation
- [ ] All public endpoints have OpenAPI annotations
- [ ] Request/response schemas are documented
- [ ] Error responses use RFC 9457 Problem Detail format
- [ ] API versioning strategy is documented
- [ ] Authentication requirements are noted per endpoint

### Code Documentation
- [ ] All public classes have Javadoc
- [ ] All public methods have `@param`, `@return`, `@throws`
- [ ] Complex algorithms have inline comments explaining "why"
- [ ] Package-info.java exists for every package
- [ ] Thread safety characteristics documented where relevant

### Project Documentation
- [ ] README covers setup, build, and run instructions
- [ ] CONTRIBUTING.md explains development workflow
- [ ] CHANGELOG.md follows Keep a Changelog format
- [ ] Architecture Decision Records exist for key decisions
- [ ] Deployment documentation is current
