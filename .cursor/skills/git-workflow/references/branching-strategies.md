# Branching Strategies

## Trunk-Based Development (Recommended)

All developers commit to `main` via short-lived feature branches. The default for most teams.

```
main ─────●──●──●──●──●──●──●──●── (always deployable)
           \    /  \      /
feature/a   ●──●    \    /
                     ●──●
                   feature/b
```

**Characteristics:**
- Feature branches live < 3 days
- Squash-merge into `main`
- CI/CD deploys from `main` continuously
- Feature flags hide incomplete work

**Best for:** Small-to-medium teams, continuous deployment, microservices.

## GitHub Flow

Simplified variant of trunk-based. Feature branches, PRs, merge to `main`, deploy.

1. Create branch from `main`
2. Develop and commit
3. Open pull request
4. Review, discuss, iterate
5. Merge to `main`
6. Deploy

**Best for:** Open source projects, teams new to Git workflows.

## GitFlow

Structured model with `develop`, `release`, and `hotfix` branches. More ceremony, more control.

```
main     ─────●─────────────────●───── (tagged releases only)
               \               /
develop  ──●──●──●──●──●──●──●──●──── (integration branch)
            \    /     \      /
feature/x    ●──●       ●──●
                      release/1.0
```

**Characteristics:**
- `develop` branch for integration
- `release/*` branches for stabilization
- `hotfix/*` branches for emergency fixes to production
- Tagged releases on `main`

**Best for:** Packaged software, mobile apps, scheduled releases, large teams.

## Comparison

| Aspect | Trunk-Based | GitHub Flow | GitFlow |
|--------|-------------|-------------|---------|
| Complexity | Low | Low | High |
| Branch lifetime | Hours-days | Days | Days-weeks |
| Deploy frequency | Continuous | Per merge | Scheduled |
| Release process | Tag main | Tag main | Release branch |
| Team size fit | Any | Small-medium | Medium-large |
| Merge conflicts | Rare | Occasional | Frequent |

## Choosing a Strategy

- **Start with trunk-based** unless you have a specific reason not to
- Switch to GitFlow if you need: scheduled releases, long stabilization, parallel release support
- Use GitHub Flow for open source or very simple projects
- Document the chosen strategy in the project README or contributing guide
