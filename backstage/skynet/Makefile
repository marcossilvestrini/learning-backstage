-include .env
export

dev: ## Start the application concurrently
	yarn concurrently "yarn start" "yarn start-backend"

start: ## Start the application
	yarn workspace app start

start-backend: ## Start the backend
	yarn workspace backend start

build-backend: ## Build the backend
	yarn workspace backend build

build-all: ## Build all repo components
	yarn backstage-cli repo build --all

build-image: ## Build backend image
	yarn workspace backend build-image

tsc: ## Compile TypeScript code
	yarn tsc

tsc-full: ## Compile TypeScript code with full checks
	yarn tsc --skipLibCheck false --incremental false

clean: ## Clean repo using backstage-cli
	yarn backstage-cli repo clean

test: ## Run tests
	yarn backstage-cli repo test

test-all: ## Run all tests with coverage
	yarn backstage-cli repo test --coverage

test-e2e: ## Run end-to-end tests
	yarn playwright test

fix: ## Fix repo using backstage-cli
	yarn backstage-cli repo fix

lint: ## Lint codebase since master
	yarn backstage-cli repo lint --since origin/master

lint-all: ## Lint entire codebase
	yarn backstage-cli repo lint

prettier-check: ## Check code format using prettier
	yarn prettier --check .

prettier-fix: ## Fix code format using prettier
	yarn prettier --write .

new: ## Create a new component with internal scope
	yarn backstage-cli new --scope internal

help: ## Display this help
	@echo "Usage: make [TARGET]\nTargets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: dev start start-backend build-backend build-all build-image tsc tsc-full clean test test-all test-e2e fix lint lint-all prettier-check prettier-fix new help