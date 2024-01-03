# Import variables from .env
include .env
export

# Service name
SERVICE_NAME = backstage

# Package management tool
PM = yarn

install: ## Install dependencies 
	$(PM) install

install-yaml-tools: ## Install YAML tools (assumes you have Python & pip installed for yamllint)
	pip install yamllint
	$(PM) add --dev prettier -W

helm-install: ## Install helm package
	helm install $(SERVICE_NAME) helm/$(SERVICE_NAME)

install_tilt: ## Install tilt development
	@curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash

install_cluster: ## Install k3d cluster
	@curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

config_hosts: ## Configure host for local registry
	@grep -q '127.0.0.1 registry-local' /etc/hosts || (echo "# Cluster k3d backstage" | sudo tee -a /etc/hosts && echo "127.0.0.1 registry-local" | sudo tee -a /etc/hosts)

launch_cluster: ## Launch k3d cluster
	@k3d cluster create backstage --registry-create registry-local --port 5000 -p "3000:30080@agent:0" -p "7007:80@loadbalancer" --agents 2 

delete_cluster: ## Delete k3d cluster
	@k3d cluster delete backstage

new: ## Create a new Backstage component/plugin
	$(PM) run new

dev: ## Start the development environment
	$(PM) run dev

start: ## Start the frontend
	$(PM) run start

start-backend: ## Start the backend
	$(PM) run start-backend

stop-all: ## Stop all node processes in the current directory
	@pkill -f "$(PWD)/.*node"

check-versions: ## Check and fix Backstage package versions
	$(PM) backstage-cli versions:check --fix

check-yaml: ## Check YAML formatting and syntax	
	@find . -type f \( -iname "*.yml" -or -iname "*.yaml" \) ! -path "./node_modules/*" | xargs prettier --check

update: ## Update Backstage
	$(PM) backstage-cli versions:bump

build-backend: ## Build the backend
	$(PM) run build:backend

build-all: ## Build all components
	$(PM) run build:all

build-image: ## Build the Docker image for the backend
	$(PM) run build-image

tsc: ## Run TypeScript compiler
	$(PM) run tsc 

tsc-full: ## Run TypeScript compiler with full checks
	$(PM) run tsc:full

test: ## Run tests
	$(PM) run test

test-all: ## Run all tests with coverage
	$(PM) run test:all

test-e2e: ## Run end-to-end tests
	$(PM) run test:e2e

fix: ## Auto-fix issues in the repo
	$(PM) run fix

fix-yaml: ## Format YAML files
	@find . -type f \( -iname "*.yml" -or -iname "*.yaml" \) ! -path "./node_modules/*" | xargs prettier --write

lint: ## Lint changed files since main branch
	$(PM) run lint

lint-all: ## Lint all files in the repo
	$(PM) run lint:all

prettier-check: ## Check formatting with Prettier
	$(PM) run prettier:check

prettier-fix: ## Auto-fix code style issues with Prettier
	$(PM) run prettier --write .

clean: ## Clean the repo
	$(PM) run clean

.PHONY: new dev start start-backend stop-all \
	build-backend build-all build-image \
	tsc tsc-full clean \
	test test-all test-e2e \
	fix lint lint-all prettier-check \
	validate-yaml check-versions update \
	helm-install install-yaml-tools \
	install_tilt install_cluster config_hosts launch_cluster delete_cluster \
	help

help: ## Display a list of available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36mmake %-30s\033[0m %s\n", $$1, $$2}'
