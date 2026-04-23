# Java Modernization Checklist

Use this checklist when planning and executing a Java/Spring modernization effort.

## Pre-Migration Assessment

- [ ] Document current Java version, Spring version, and dependency baseline
- [ ] Run `./mvnw dependency:tree` to capture full dependency graph
- [ ] Identify deprecated APIs in use (`jdeprscan`)
- [ ] Check all direct dependencies for target version compatibility
- [ ] Review CI/CD pipeline JDK configuration
- [ ] Ensure comprehensive test coverage before migration (>= 70%)
- [ ] Create migration branch from stable baseline

## Java Version Upgrade

- [ ] Update `maven-compiler-plugin` source/target version
- [ ] Update `java.version` property in POM
- [ ] Fix removed API usage (JAXB, javax.annotation, etc.)
- [ ] Add `--add-opens` flags temporarily if needed
- [ ] Run compilation: `./mvnw compile`
- [ ] Run full test suite: `./mvnw clean verify`
- [ ] Update `.java-version` file
- [ ] Update CI pipeline JDK version
- [ ] Update Docker base images

## Namespace Migration (javax -> jakarta)

- [ ] Replace all `javax.servlet.*` with `jakarta.servlet.*`
- [ ] Replace all `javax.persistence.*` with `jakarta.persistence.*`
- [ ] Replace all `javax.validation.*` with `jakarta.validation.*`
- [ ] Replace all `javax.annotation.*` with `jakarta.annotation.*`
- [ ] Verify no mixed `javax` / `jakarta` usage
- [ ] Run compilation and tests

## Spring Boot Upgrade

- [ ] Update Spring Boot parent POM version
- [ ] Fix compilation errors from removed/changed APIs
- [ ] Migrate `@MockBean` -> `@MockitoBean`
- [ ] Migrate `SecurityFilterChain` if using deprecated patterns
- [ ] Review `application.properties` for renamed keys
- [ ] Run `spring-boot-properties-migrator` if available
- [ ] Run full test suite
- [ ] Smoke test key endpoints

## Modern Feature Adoption

- [ ] Convert eligible POJOs to records
- [ ] Apply sealed classes where type hierarchies are closed
- [ ] Use pattern matching for instanceof where applicable
- [ ] Convert if-else chains to switch expressions
- [ ] Use text blocks for multi-line strings
- [ ] Evaluate virtual threads for I/O-bound services
- [ ] Replace ThreadLocal with ScopedValue where appropriate
- [ ] Use sequenced collection methods (`getFirst()`, `getLast()`)

## Post-Migration Verification

- [ ] All tests pass: `./mvnw clean verify`
- [ ] No compiler warnings
- [ ] Static analysis clean (Checkstyle, SpotBugs)
- [ ] Dependency vulnerability scan clean
- [ ] Performance regression testing
- [ ] Documentation updated (README, version matrix)
- [ ] Migration branch merged
