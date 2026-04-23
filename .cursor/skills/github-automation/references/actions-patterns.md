# GitHub Actions Patterns

## Reusable Workflows

Define once, call from multiple workflows:

```yaml
# .github/workflows/reusable-test.yml
name: Reusable Test
on:
  workflow_call:
    inputs:
      java-version:
        required: true
        type: string

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: ${{ inputs.java-version }}
          distribution: temurin
          cache: maven
      - run: ./mvnw verify
```

Call it:

```yaml
jobs:
  test-java-21:
    uses: ./.github/workflows/reusable-test.yml
    with:
      java-version: '21'
```

## Matrix Builds

Test across multiple versions or platforms:

```yaml
jobs:
  test:
    strategy:
      matrix:
        java-version: ['17', '21']
        os: [ubuntu-latest, windows-latest]
      fail-fast: false
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: ${{ matrix.java-version }}
          distribution: temurin
      - run: ./mvnw verify
```

## Caching

Speed up builds by caching dependencies:

```yaml
- uses: actions/setup-java@v4
  with:
    java-version: '21'
    distribution: temurin
    cache: maven

# Or explicit cache:
- uses: actions/cache@v4
  with:
    path: ~/.m2/repository
    key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
    restore-keys: ${{ runner.os }}-maven-
```

## Concurrency Control

Cancel superseded runs on the same branch:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

## Conditional Execution

```yaml
# Run only on main branch
- run: deploy.sh
  if: github.ref == 'refs/heads/main'

# Run only when specific files change
on:
  push:
    paths:
      - 'src/**'
      - 'pom.xml'

# Skip if commit message contains [skip ci]
- run: test.sh
  if: "!contains(github.event.head_commit.message, '[skip ci]')"
```

## Secrets Management

```yaml
# Reference secrets
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}

# Use environment-specific secrets
jobs:
  deploy:
    environment: production
    steps:
      - run: deploy.sh
        env:
          API_KEY: ${{ secrets.PROD_API_KEY }}
```

## Artifact Sharing Between Jobs

```yaml
jobs:
  build:
    steps:
      - run: ./mvnw package -DskipTests
      - uses: actions/upload-artifact@v4
        with:
          name: app-jar
          path: target/*.jar

  deploy:
    needs: build
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: app-jar
```

## Security Best Practices

- Pin action versions to full SHA: `actions/checkout@abc123...` not `@v4`
- Use `permissions` to limit `GITHUB_TOKEN` scope
- Never echo secrets or use them in `if` conditions
- Use `environment` for deployment approvals
- Audit third-party actions before use
