.PHONY: install setup lint test run build clean deploy-dev deploy-test deploy-prod docs test-report

install:
	pip install -r requirements.txt

setup:
	mkdir -p $(HOME)/.dbt
	cp .github/profiles/profiles.yml $(HOME)/.dbt/profiles.yml

lint:
	sqlfluff lint models/ --dialect duckdb
	yamllint -c .yamllint.yml . --no-warnings

test:
	dbt deps
	dbt seed
	dbt run
	dbt test

test-report:
	@bash scripts/test_report.sh

run:
	dbt run

build:
	dbt build

clean:
	rm -rf target/ dbt_packages/ .duckdb/

deploy-dev:
	dbt seed --target dev
	dbt run --target dev
	dbt test --target dev

deploy-test:
	dbt seed --target test
	dbt run --target test
	dbt test --target test

deploy-prod:
	dbt seed --target prod
	dbt run --target prod
	dbt test --target prod

docs:
	dbt docs generate
	dbt docs serve
