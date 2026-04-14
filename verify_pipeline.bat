@echo off
REM FDSP CI/CD Pipeline Verification Script

echo =========================================
echo FDSP Data Platform - Pipeline Verification
echo =========================================
echo.

echo [1/5] Checking SQL Linting...
sqlfluff lint models/ --dialect duckdb
if %errorlevel% neq 0 (
    echo FAILED: SQL Linting
    exit /b 1
)
echo PASSED: SQL Linting
echo.

echo [2/5] Checking YAML Linting...
yamllint -c .yamllint.yml . --no-warnings
if %errorlevel% neq 0 (
    echo FAILED: YAML Linting
    exit /b 1
)
echo PASSED: YAML Linting
echo.

echo [3/5] Running dbt seed...
dbt seed
if %errorlevel% neq 0 (
    echo FAILED: dbt seed
    exit /b 1
)
echo PASSED: dbt seed
echo.

echo [4/5] Running dbt models...
dbt run
if %errorlevel% neq 0 (
    echo FAILED: dbt run
    exit /b 1
)
echo PASSED: dbt run
echo.

echo [5/5] Running dbt tests...
dbt test
if %errorlevel% neq 0 (
    echo FAILED: dbt test
    exit /b 1
)
echo PASSED: dbt test
echo.

echo =========================================
echo ALL CHECKS PASSED!
echo =========================================
echo.
echo Pipeline Status: READY FOR DEPLOYMENT
echo Total Tests: 12
echo - Schema Tests: 9
echo - Custom Tests: 3
echo.
echo Next Steps:
echo 1. Commit and push changes to GitHub
echo 2. Create pull request to dev branch
echo 3. CI pipeline will run automatically
echo 4. Merge to deploy to dev environment
echo.

exit /b 0
