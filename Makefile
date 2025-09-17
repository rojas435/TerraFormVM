# Terraform Project Makefile
# Usage: make <target> ENV=<environment>
# Example: make plan ENV=dev

# Default environment
ENV ?= dev

# Validate environment
VALID_ENVS := dev staging production
ifeq ($(filter $(ENV),$(VALID_ENVS)),)
$(error Invalid environment. Use: dev, staging, or production)
endif

# Terraform directory for the specified environment
TF_DIR := environments/$(ENV)

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

.PHONY: help init plan apply destroy fmt validate clean check-env

help: ## Show this help message
	@echo "Terraform DevOps Project - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "Usage: make <target> ENV=<environment>"
	@echo "Valid environments: $(VALID_ENVS)"
	@echo ""
	@echo "Examples:"
	@echo "  make init ENV=dev"
	@echo "  make plan ENV=staging"
	@echo "  make apply ENV=production"

check-env: ## Validate environment parameter
	@if [ ! -d "$(TF_DIR)" ]; then \
		echo "$(RED)Error: Environment '$(ENV)' not found!$(NC)"; \
		echo "Available environments: $(VALID_ENVS)"; \
		exit 1; \
	fi

init: check-env ## Initialize Terraform for the specified environment
	@echo "$(GREEN)Initializing Terraform for $(ENV) environment...$(NC)"
	cd $(TF_DIR) && terraform init

plan: check-env ## Show Terraform execution plan for the specified environment
	@echo "$(GREEN)Creating execution plan for $(ENV) environment...$(NC)"
	cd $(TF_DIR) && terraform plan

apply: check-env ## Apply Terraform configuration for the specified environment
	@echo "$(YELLOW)Applying configuration for $(ENV) environment...$(NC)"
	@echo "$(RED)WARNING: This will create/modify Azure resources!$(NC)"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ]
	cd $(TF_DIR) && terraform apply

destroy: check-env ## Destroy all resources for the specified environment
	@echo "$(RED)WARNING: This will DESTROY all resources in $(ENV) environment!$(NC)"
	@read -p "Are you ABSOLUTELY sure? Type 'yes' to continue: " confirm && [ "$$confirm" = "yes" ]
	cd $(TF_DIR) && terraform destroy

fmt: ## Format all Terraform files
	@echo "$(GREEN)Formatting Terraform files...$(NC)"
	terraform fmt -recursive .

validate: check-env ## Validate Terraform configuration for the specified environment
	@echo "$(GREEN)Validating Terraform configuration for $(ENV) environment...$(NC)"
	cd $(TF_DIR) && terraform validate

clean: check-env ## Clean Terraform temporary files for the specified environment
	@echo "$(GREEN)Cleaning temporary files for $(ENV) environment...$(NC)"
	cd $(TF_DIR) && rm -rf .terraform .terraform.lock.hcl terraform.tfstate.backup

show: check-env ## Show current state for the specified environment
	@echo "$(GREEN)Showing current state for $(ENV) environment...$(NC)"
	cd $(TF_DIR) && terraform show

output: check-env ## Show outputs for the specified environment
	@echo "$(GREEN)Showing outputs for $(ENV) environment...$(NC)"
	cd $(TF_DIR) && terraform output

state-list: check-env ## List all resources in state for the specified environment
	@echo "$(GREEN)Listing resources in state for $(ENV) environment...$(NC)"
	cd $(TF_DIR) && terraform state list

docs: ## Generate module documentation
	@echo "$(GREEN)Generating module documentation...$(NC)"
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table --output-file README.md modules/networking/; \
		terraform-docs markdown table --output-file README.md modules/compute/; \
		terraform-docs markdown table --output-file README.md modules/security/; \
		echo "Documentation generated successfully!"; \
	else \
		echo "$(YELLOW)terraform-docs not found. Install it from: https://github.com/terraform-docs/terraform-docs$(NC)"; \
	fi

all-envs-plan: ## Run plan for all environments
	@for env in $(VALID_ENVS); do \
		echo "$(GREEN)Planning for $$env environment...$(NC)"; \
		$(MAKE) plan ENV=$$env; \
	done

all-envs-validate: ## Validate all environments
	@for env in $(VALID_ENVS); do \
		echo "$(GREEN)Validating $$env environment...$(NC)"; \
		$(MAKE) validate ENV=$$env; \
	done