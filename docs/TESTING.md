# Testing Guide

## Overview

This document describes the testing strategy for the FDSP Data Platform.

## Test Types

### 1. Schema Tests (Built-in dbt tests)

Located in `models/schema.yml`:

- **Uniqueness Tests**: Ensure primary keys are unique
  - `customer_id` in all models
  
- **Not Null Tests**: Ensure required fields have values
  - `customer_id` in all models
  - `customer_name` in staging models
  
- **Accepted Values Tests**: Validate categorical data
  - `status` in raw_customers (active, inactive)
  - `region` in dim_customers (APAC, WEST, OTHER)

### 2. Custom Data Tests

Located in `tests/` directory:

- **assert_dim_customers_has_data.sql**: Ensures dim_customers table has at least one record
- **assert_dim_customers_only_active.sql**: Validates only active customers are in dim_customers
- **assert_region_mapping_correct.sql**: Verifies region mapping logic is correct

### 3. Linting Tests

- **SQL Linting**: Uses sqlfluff to enforce SQL code standards
- **YAML Linting**: Uses yamllint to validate YAML configuration files

## Running Tests Locally

### Run All Tests
```bash
make test
```

### Run Individual Test Types
```bash
# Linting only
make lint

# dbt tests only
dbt test

# Specific test
dbt test --select test_name
```

### Run Test Report
```bash
make test-report
```

## CI/CD Testing

### Pull Request Tests (CI Pipeline)
Triggered on: Pull requests to dev, test, main branches

Steps:
1. SQL linting
2. YAML linting
3. dbt seed
4. dbt run
5. dbt test
6. Generate documentation

### Deployment Tests (CD Pipeline)
Triggered on: Push to dev, test, main branches

Steps:
1. Deploy to target environment
2. Run all tests in target environment
3. Generate environment-specific documentation

### Scheduled Tests
Triggered: Daily at 6 AM UTC

Steps:
1. Run full test suite on production
2. Upload test results
3. Alert on failures

## Test Coverage

Current test coverage:

| Model | Schema Tests | Custom Tests | Total |
|-------|-------------|--------------|-------|
| raw_customers | 3 | 0 | 3 |
| stg_customers | 3 | 0 | 3 |
| dim_customers | 3 | 3 | 6 |
| **Total** | **9** | **3** | **12** |

## Adding New Tests

### Schema Test
Add to `models/schema.yml`:
```yaml
- name: column_name
  tests:
    - unique
    - not_null
```

### Custom Test
Create SQL file in `tests/`:
```sql
-- tests/my_custom_test.sql
select *
from {{ ref('model_name') }}
where condition_that_should_not_exist
```

## Test Best Practices

1. **Test Early**: Run tests locally before committing
2. **Test Often**: Use pre-commit hooks
3. **Test Coverage**: Aim for 100% model coverage
4. **Test Quality**: Focus on business logic validation
5. **Test Performance**: Keep tests fast and efficient

## Troubleshooting

### Test Failures
```bash
# View detailed test results
cat target/run_results.json

# Run specific failing test
dbt test --select test_name
```

### Linting Failures
```bash
# Auto-fix SQL issues
sqlfluff fix models/ --dialect duckdb

# Check specific file
sqlfluff lint models/path/to/file.sql --dialect duckdb
```
