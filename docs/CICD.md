# CI/CD Pipeline Documentation

## Overview

The FDSP project uses GitHub Actions for continuous integration and deployment across three environments: dev, test, and prod.

## Workflows

### 1. CI Pipeline (`.github/workflows/ci.yml`)

**Triggers:**
- Pull requests to `dev`, `test`, `main` branches
- Push to `dev` branch

**Jobs:**

#### Lint Job
- SQL linting with sqlfluff
- YAML linting with yamllint
- Fails fast if code quality issues found

#### DBT Test Job
- Installs dependencies from requirements.txt
- Runs dbt seed, run, and test
- Generates documentation
- Uploads artifacts for review

**Status:** Required for PR merge

### 2. CD Pipeline (`.github/workflows/cd.yml`)

**Triggers:**
- Push to `dev`, `test`, `main` branches

**Environment Mapping:**
- `dev` branch → dev environment
- `test` branch → test environment
- `main` branch → prod environment

**Jobs:**

#### Deploy Job
- Sets environment based on branch
- Runs full dbt pipeline
- Generates environment-specific docs
- Uploads docs as artifacts (30-day retention)
- Provides deployment summary

**Environment Protection:**
- Uses GitHub environments for approval gates
- Recommended: Require approval for test/prod

### 3. Scheduled Tests (`.github/workflows/scheduled-tests.yml`)

**Triggers:**
- Daily at 6 AM UTC (cron: `0 6 * * *`)
- Manual trigger via workflow_dispatch

**Jobs:**

#### Data Quality Job
- Runs against production environment
- Executes full test suite
- Uploads test results (90-day retention)
- Alerts on failures

## Branch Strategy

```
main (prod)
  ↑
test (staging)
  ↑
dev (development)
  ↑
feature/* (feature branches)
```

### Workflow:
1. Create feature branch from `dev`
2. Develop and test locally
3. Create PR to `dev` → CI runs
4. Merge to `dev` → Auto-deploy to dev
5. Create PR from `dev` to `test` → CI runs
6. Merge to `test` → Auto-deploy to test
7. Create PR from `test` to `main` → CI runs
8. Merge to `main` → Auto-deploy to prod

## Environment Configuration

### Dev Environment
- Database: `.duckdb/dbt_poc.duckdb`
- Threads: 4
- Purpose: Development and testing

### Test Environment
- Database: `.duckdb/dbt_poc_test.duckdb`
- Threads: 4
- Purpose: Pre-production validation

### Prod Environment
- Database: `.duckdb/dbt_poc_prod.duckdb`
- Threads: 8
- Purpose: Production data

## Artifacts

### CI Artifacts
- **dbt-artifacts**: Contains compiled models, test results, and documentation
- **Retention**: 7 days

### CD Artifacts
- **dbt-docs-{env}**: Environment-specific documentation
- **Retention**: 30 days

### Scheduled Test Artifacts
- **test-results-{run_number}**: Test execution results
- **Retention**: 90 days

## Setup GitHub Environments

1. Go to repository Settings → Environments
2. Create environments: `dev`, `test`, `main`
3. Configure protection rules:
   - **dev**: No restrictions
   - **test**: Require 1 reviewer
   - **main**: Require 2 reviewers + wait timer

## Monitoring

### Check Pipeline Status
```bash
# View workflow runs
gh run list

# View specific run
gh run view <run-id>

# Download artifacts
gh run download <run-id>
```

### View Test Results
- Check Actions tab in GitHub
- Download artifacts from workflow runs
- Review `target/run_results.json`

## Troubleshooting

### Pipeline Failures

**Linting Failures:**
```bash
# Fix locally
make lint
sqlfluff fix models/ --dialect duckdb
```

**Test Failures:**
```bash
# Run locally
make test
dbt test --select failing_test
```

**Deployment Failures:**
- Check environment configuration
- Verify dbt profiles
- Review workflow logs

## Best Practices

1. **Always run tests locally** before pushing
2. **Use feature branches** for development
3. **Keep PRs small** and focused
4. **Review CI results** before merging
5. **Monitor scheduled tests** for data quality issues
6. **Use semantic commit messages**
7. **Tag releases** on main branch

## Notifications

Configure GitHub notifications for:
- Workflow failures
- PR reviews
- Deployment status

## Security

- Never commit credentials
- Use GitHub Secrets for sensitive data
- Review `.gitignore` before committing
- Rotate secrets regularly
