.PHONY: install test lint build deploy clean

install:
	pip install -e .[test]
	@./scripts/setup-hooks.sh

test:
	pytest

lint:
	flake8 src tests

build:
	docker compose build

deploy:
	./scripts/deploy.sh

infra-up:
	cd infrastructure/jenkins && docker compose up -d --build
	@echo "-------------------------------------------------------"
	@echo "Jenkins is starting up..."
	@echo "Access URL: http://localhost:8080"
	@echo "Login Credentials:"
	@echo "  Username: admin"
	@echo "  Password: admin"
	@echo "-------------------------------------------------------"

infra-down:
	cd infrastructure/jenkins && docker compose down

app-down:
	docker compose down

destroy: clean app-down infra-down
	@echo "Environment stopped and containers removed (data preserved in volumes)"

nuke: clean
	docker compose down -v --rmi local
	cd infrastructure/jenkins && docker compose down -v --rmi local
	# Remove manually built images (from Jenkins builds or manual docker build)
	@docker images --format '{{.Repository}}:{{.Tag}}' | grep 'aceest-fitness' | xargs -r docker rmi -f
	rm -rf infrastructure/jenkins/jenkins_home
	@echo "Environment completely obliterated (volumes, data, and local images removed)"

clean:
	rm -rf .pytest_cache
	rm -rf .coverage
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name "*.egg-info" -exec rm -rf {} +
