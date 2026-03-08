.PHONY: install test lint build deploy clean

install:
	pip install -e .[test]

test:
	pytest

lint:
	flake8 src tests

build:
	docker compose build

deploy:
	./scripts/deploy.sh

clean:
	rm -rf .pytest_cache
	rm -rf .coverage
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name "*.egg-info" -exec rm -rf {} +
