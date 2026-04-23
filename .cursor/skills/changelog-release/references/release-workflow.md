# Release Workflow

## Manual Release Process

### 1. Prepare

```bash
git checkout main
git pull origin main

LAST_TAG=$(git describe --tags --abbrev=0)
echo "Last release: $LAST_TAG"
git log "$LAST_TAG"..HEAD --oneline
```

### 2. Update Changelog

Move entries from `[Unreleased]` to a new version section in `CHANGELOG.md`.

### 3. Bump Version

Update version in `pom.xml` using the Maven Versions plugin:

```bash
VERSION="2.5.0"
./mvnw versions:set -DnewVersion=$VERSION -DgenerateBackupPoms=false
```

For multi-module projects, this updates the parent and all child modules.

### 4. Commit and Tag

```bash
git add CHANGELOG.md pom.xml **/pom.xml
git commit -m "chore(release): Prepare v$VERSION"
git tag -a "v$VERSION" -m "Release $VERSION"
```

### 5. Push and Publish

```bash
git push origin main --tags

./mvnw clean verify -DskipTests

gh release create "v$VERSION" \
  --title "v$VERSION" \
  --notes "See CHANGELOG.md for details" \
  target/*.jar
```

## Automated Release with GitHub Actions

See `github-automation` skill for the release workflow template at `assets/workflow-templates/release.yml`.

The automated flow:
1. Push a tag (`v*`) to trigger the release workflow
2. Workflow builds the artifact with `./mvnw clean verify`
3. Generates changelog from commit messages
4. Creates a GitHub Release with notes and JAR artifacts

## Release Checklist

- [ ] All CI checks pass on `main`
- [ ] Changelog is updated with all changes
- [ ] Version is bumped in `pom.xml` (parent and modules)
- [ ] No pending PRs that should be included
- [ ] Release notes are human-readable (not just commit log)
- [ ] Breaking changes are documented with migration instructions
- [ ] Tag follows `v<MAJOR>.<MINOR>.<PATCH>` format
- [ ] JAR artifacts are attached to the release
- [ ] Maven Central / internal registry deployment (if applicable)

## Hotfix Release

For urgent production fixes:

```bash
git checkout -b hotfix/critical-fix main
# Make the fix and update pom.xml
./mvnw versions:set -DnewVersion=2.4.2 -DgenerateBackupPoms=false
git commit -am "fix: Patch critical security vulnerability"
git checkout main
git merge hotfix/critical-fix
git tag -a "v2.4.2" -m "Hotfix: critical security patch"
git push origin main --tags
git branch -d hotfix/critical-fix
```

## Rollback

If a release must be rolled back:

```bash
git revert HEAD
git push origin main

# Do NOT delete the tag -- it documents the failed release
# Create a new patch release instead
```
