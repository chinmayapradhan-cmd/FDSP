# FDSP - Data Platform CI/CD Pipeline

Implementation of CI/CD Pipeline for the FDSP project to automate manual tasks and streamline data transformations.

## Overview

This project uses dbt (data build tool) with DuckDB for data transformations and includes a complete CI/CD pipeline using GitHub Actions.

## Quick Start

### Prerequisites
- Python 3.11+
- pip

### Installation

```bash
# Install dependencies
pip install -r requirements.txt

# Setup dbt profiles
make setup

# Or manually:
mkdir -p ~/.dbt
cp .github/profiles/profiles.yml ~/.dbt/profiles.yml
```

### Running Locally

```bash
# Run all steps
make test

# Or individually:
dbt seed    # Load seed data
dbt run     # Run models
dbt test    # Run tests
```

## CI/CD Pipeline

### Workflows

1. **CI Pipeline** (`.github/workflows/ci.yml`)
   - Triggers on: Pull requests and pushes to dev
   - Steps: Lint SQL/YAML → Run dbt tests → Generate docs

2. **CD Pipeline** (`.github/workflows/cd.yml`)
   - Triggers on: Push to dev/test/main branches
   - Steps: Deploy to respective environment

3. **Scheduled Tests** (`.github/workflows/scheduled-tests.yml`)
   - Triggers on: Daily at 6 AM UTC
   - Steps: Run data quality tests

### Environments

- **dev**: Development environment
- **test**: Testing/staging environment
- **prod**: Production environment

## Project Structure

```
.
├── .github/
│   ├── workflows/          # CI/CD pipelines
│   ├── profiles/           # dbt profiles
│   └── ISSUE_TEMPLATE/     # Issue templates
├── models/
│   ├── staging/            # Staging models
│   └── marts/              # Dimensional models
├── seeds/                  # Seed data
├── tests/                  # Custom tests
└── dbt_project.yml         # dbt configuration
```

## Development Workflow

1. Create feature branch from `dev`
2. Make changes
3. Run locally: `make test`
4. Commit and push
5. Create PR → CI runs automatically
6. Merge to `dev` → Auto-deploy to dev environment
7. Promote to `test` → Auto-deploy to test environment
8. Promote to `main` → Auto-deploy to prod environment

## Docker Support

```bash
# Build and run
docker-compose up dbt-dev

# Run docs server
docker-compose up dbt-docs
```

## Pre-commit Hooks

```bash
# Install pre-commit
pip install pre-commit
pre-commit install

# Run manually
pre-commit run --all-files
```

## Makefile Commands

- `make install` - Install dependencies
- `make setup` - Setup dbt profiles
- `make lint` - Run linters
- `make test` - Run full test suite
- `make deploy-dev` - Deploy to dev
- `make deploy-test` - Deploy to test
- `make deploy-prod` - Deploy to prod
- `make docs` - Generate and serve docs

## Contributing

See [pull request template](.github/pull_request_template.md) for guidelines.
