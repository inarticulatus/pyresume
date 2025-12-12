# Makefile for PyResume Project
# Manages the entire resume generation pipeline

# ============================================================================
# Variables
# ============================================================================

# Python and environment
VENV_DIR := .venv
VENV_PYTHON := $(VENV_DIR)/bin/python
VENV_PIP := $(VENV_DIR)/bin/pip
REQUIREMENTS := requirements.txt

# Resume generation
DATA_DIR := data
OUTPUT_NAME := resume
TEMPLATE := awesome-cv.tex
GENERATOR := scripts/generate_resume.py

# Directories
OUTPUT_DIR := output
TEMPLATES_DIR := templates

# Code quality tools
BLACK := $(VENV_DIR)/bin/black
RUFF := $(VENV_DIR)/bin/ruff

# ============================================================================
# Default Target
# ============================================================================

.DEFAULT_GOAL := help

# ============================================================================
# Build Targets
# ============================================================================

.PHONY: build
build: check-env ## Generate resume PDF from YAML (use: make build DATA_DIR=my_data OUTPUT_NAME=my_resume)
	@echo "Generating resume..."
	$(VENV_PYTHON) $(GENERATOR) --yaml $(DATA_DIR) --template $(TEMPLATE) --output $(OUTPUT_NAME)
	@echo "Created at $(OUTPUT_DIR)/$(OUTPUT_NAME).pdf"

# ============================================================================
# Environment Management
# ============================================================================

.PHONY: setup
setup: ## Create Python virtual environment and install dependencies
	@if [ -d "$(VENV_DIR)" ]; then \
		echo "#  Virtual environment already exists. Use 'make env-update' to update it."; \
	else \
		echo "# Creating Python virtual environment..."; \
		python3 -m venv $(VENV_DIR); \
		$(VENV_PIP) install --upgrade pip; \
		$(VENV_PIP) install -r $(REQUIREMENTS); \
		echo "# Done! Activate with: source $(VENV_DIR)/bin/activate"; \
	fi

.PHONY: env-update
env-update: check-env ## Update virtual environment dependencies from requirements.txt
	@echo "# Updating dependencies..."
	@$(VENV_PIP) install --upgrade pip
	@$(VENV_PIP) install -r $(REQUIREMENTS) --upgrade
	@echo "# Done!"

.PHONY: env-clean
env-clean: ## Remove virtual environment
	@read -p "Remove virtual environment? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -rf $(VENV_DIR); \
		echo "# Done!"; \
	else \
		echo "❌ Cancelled."; \
	fi

.PHONY: check-env
check-env: ## Verify virtual environment exists
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "❌ Virtual environment not found."; \
		echo "Please run: make setup"; \
		exit 1; \
	fi

# ============================================================================
# Cleaning Targets
# ============================================================================

.PHONY: clean
clean: ## Remove generated output files (.tex, .pdf)
	@rm -f $(OUTPUT_DIR)/*.tex $(OUTPUT_DIR)/*.pdf
	@echo "# Cleaned output files"

.PHONY: clean-all
clean-all: clean ## Remove all generated files and build artifacts
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type f -name "*.pyo" -delete 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@echo "# Deep cleaned"

# ============================================================================
# Development Targets
# ============================================================================

.PHONY: lint
lint: check-env ## Run code quality checks (black, ruff)
	@echo "# Checking code quality..."
	@$(BLACK) --check $(GENERATOR) || (echo "❌ Formatting issues. Run 'make format' to fix." && exit 1)
	@$(RUFF) check $(GENERATOR) || (echo "❌ Linting issues found." && exit 1)
	@echo "# All checks passed!"

.PHONY: format
format: check-env ## Auto-format Python code with black
	@$(BLACK) $(GENERATOR)
	@echo "# Formatted"

.PHONY: ruff-fix
ruff-fix: check-env ## Auto-fix linting issues with ruff
	@$(RUFF) check --fix $(GENERATOR)
	@echo "# Fixed"

# ============================================================================
# Utility Targets
# ============================================================================

.PHONY: validate-yaml
validate-yaml: check-env ## Validate all YAML files in data directory
	@$(VENV_PYTHON) -c "import yaml; from pathlib import Path; [yaml.safe_load(open(f)) for f in Path('$(DATA_DIR)').glob('*.yaml')]" && \
		echo "# All YAML files are valid" || \
		(echo "❌ YAML validation failed" && exit 1)

.PHONY: show-config
show-config: ## Show current configuration
	@echo "# Configuration:"
	@echo "  Python:     $(VENV_PYTHON)"
	@echo "  Venv:       $(VENV_DIR)"
	@echo "  Data Dir:   $(DATA_DIR)"
	@echo "  Template:   $(TEMPLATE)"
	@echo "  Output:     $(OUTPUT_NAME)"
	@echo "  Output Dir: $(OUTPUT_DIR)"

.PHONY: list-templates
list-templates: ## List available LaTeX templates
	@echo "# Available templates:"
	@ls -1 $(TEMPLATES_DIR)/*.tex 2>/dev/null || echo "  No templates found in $(TEMPLATES_DIR)/"

.PHONY: view-pdf
view-pdf: ## Open the generated PDF (Linux)
	@if [ -f "$(OUTPUT_DIR)/$(OUTPUT_NAME).pdf" ]; then \
		xdg-open "$(OUTPUT_DIR)/$(OUTPUT_NAME).pdf" 2>/dev/null || \
		echo "#!!  Could not open PDF. Please open manually: $(OUTPUT_DIR)/$(OUTPUT_NAME).pdf"; \
	else \
		echo "❌ PDF not found: $(OUTPUT_DIR)/$(OUTPUT_NAME).pdf"; \
		echo "Run 'make build' first."; \
	fi

# ============================================================================
# Help Target
# ============================================================================

.PHONY: help
help: ## Display this help message
	@echo "PyResume - LaTeX Resume Generator"
	@echo "=================================="
	@echo ""
	@echo "Usage: make [target] [VARIABLE=value]"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Variables:"
	@echo "  YAML_FILE      Resume YAML file (default: resume.yaml)"
	@echo "  OUTPUT_NAME    Output filename without extension (default: resume)"
	@echo "  TEMPLATE       Template name (default: awesome-cv.tex)"
	@echo ""
	@echo "Examples:"
	@echo "  make build                                    # Generate resume.pdf"
	@echo "  make build YAML_FILE=john.yaml OUTPUT_NAME=john_resume"
	@echo "  make clean                                    # Remove generated files"
	@echo "  make lint                                     # Check code quality"
	@echo ""
