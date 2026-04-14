#!/bin/bash
# Test Report Script for FDSP CI/CD Pipeline

echo "========================================="
echo "FDSP Data Platform - Test Report"
echo "========================================="
echo ""

# Run linting
echo "1. Running SQL Linting..."
sqlfluff lint models/ --dialect duckdb
SQL_LINT_STATUS=$?

echo ""
echo "2. Running YAML Linting..."
yamllint -c .yamllint.yml . --no-warnings
YAML_LINT_STATUS=$?

# Run dbt tests
echo ""
echo "3. Running dbt deps..."
dbt deps

echo ""
echo "4. Running dbt seed..."
dbt seed

echo ""
echo "5. Running dbt models..."
dbt run

echo ""
echo "6. Running dbt tests..."
dbt test
DBT_TEST_STATUS=$?

echo ""
echo "7. Generating documentation..."
dbt docs generate

# Summary
echo ""
echo "========================================="
echo "Test Summary"
echo "========================================="
echo "SQL Linting: $([ $SQL_LINT_STATUS -eq 0 ] && echo '✅ PASSED' || echo '❌ FAILED')"
echo "YAML Linting: $([ $YAML_LINT_STATUS -eq 0 ] && echo '✅ PASSED' || echo '❌ FAILED')"
echo "dbt Tests: $([ $DBT_TEST_STATUS -eq 0 ] && echo '✅ PASSED' || echo '❌ FAILED')"
echo "========================================="

# Exit with error if any test failed
if [ $SQL_LINT_STATUS -ne 0 ] || [ $YAML_LINT_STATUS -ne 0 ] || [ $DBT_TEST_STATUS -ne 0 ]; then
    exit 1
fi

exit 0
