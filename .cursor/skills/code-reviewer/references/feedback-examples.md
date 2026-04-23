# Feedback Examples

## Good vs Bad Feedback

### Be Specific, Not Vague
```
BAD: "This is confusing"

GOOD: "This method handles both validation and persistence. Consider
splitting into validateUser() and saveUser() for single responsibility
and easier testing."
```

### Be Actionable, Not Just Critical
```
BAD: "Fix the query"

GOOD: "This will cause N+1 queries -- one per Post. Use a @Query with
JOIN FETCH to eager load authors in a single query:
  @Query("SELECT p FROM Post p JOIN FETCH p.author")
  List<Post> findAllWithAuthors();"
```

### Be Constructive, Not Demanding
```
BAD: "Add tests"

GOOD: "Missing test for the case when email is already taken. Add a test
that verifies the service throws DuplicateEmailException and the
controller returns 409 Conflict."
```

### Ask Questions, Don't Assume
```
BAD: "This is wrong"

GOOD: "I notice this returns Optional.empty() instead of throwing
UserNotFoundException. Is that intentional? The other repository methods
throw on not-found. Should this be consistent?"
```

## Praise Examples

Reinforce good patterns with specific praise:

```
"Great use of guard clauses here -- much more readable than nested ifs."
"Nice use of records for this DTO -- immutable and concise."
"Excellent exception hierarchy -- domain-specific errors with clear messages."
"Good choice using @Transactional(readOnly = true) for the read path."
"Appreciate the comprehensive test coverage, especially the edge cases in OrderValidatorTest."
```

## Feedback by Severity

### Critical (Must Fix)
```
[CRITICAL] Security: SQL Injection
Location: com.example.user.UserRepository:45

The query uses string concatenation:
  "SELECT * FROM users WHERE email = '" + email + "'"

This is vulnerable to SQL injection. Use parameterized query:
  jdbcClient.sql("SELECT * FROM users WHERE email = :email")
      .param("email", email)
      .query(User.class)
      .single();
```

### Major (Should Fix)
```
[MAJOR] Performance: N+1 Query
Location: com.example.post.PostService:23

Current code calls userRepository.findById() inside a loop (N+1 problem).
Suggestion: Use JOIN FETCH or batch load with findAllById().
Impact: ~100 extra DB queries per request with current data volume.
```

### Minor (Nice to Have)
```
[MINOR] Naming: Unclear variable
Location: com.example.util.DateUtils:12

`d` is unclear. Consider `createdAt` or `timestamp` for better readability.

[MINOR] Style: Prefer var for local variables
Location: com.example.order.OrderService:34

`HashMap<String, List<OrderItem>> grouped = ...` could use `var grouped = ...`
since the type is clear from the right-hand side.
```

## Question Format
```
[QUESTION]
Location: com.example.order.OrderService:67

What is the expected behavior when the user has an existing pending order?
Should this: return the existing order, create a new one, or throw
DuplicateOrderException?
```

## Summary Format
```
## Summary
Overall this is a solid implementation of the user registration flow.
The validation logic with Bean Validation annotations is clean and
the exception handling with @ControllerAdvice is comprehensive.

**Blocking Issues**: 1 critical (SQL injection in UserRepository)
**Suggestions**: 2 major, 3 minor

Once the SQL injection is fixed, this is ready to merge.
```

## Quick Reference

| Feedback Type | Tone | Required Action |
|---------------|------|-----------------|
| Critical | Firm, clear | Must fix before merge |
| Major | Suggestive | Should fix |
| Minor | Optional | Nice to have |
| Praise | Positive | None -- reinforcement |
| Question | Curious | Response needed |
