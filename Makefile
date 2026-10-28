# Run `make help` to list the commands. Works with the GNU Make 3.81 that ships with macOS.

SHELL := /bin/bash
.DEFAULT_GOAL := help

# Environment to work on: a folder in parameters/ (for example `make deploy ENVIRONMENT=test`).
ENVIRONMENT ?=
TEMPLATE_FILES := $(wildcard templates/*.yml templates/*.yaml templates/*.json)
# Stacks to act on. Defaults to every template in templates/; override with STACKS="stack-a stack-b".
STACKS ?= $(sort $(basename $(notdir $(TEMPLATE_FILES))))
# GitHub repository that `make init` allows to assume the deploy role. Detected from the origin remote.
ifeq ($(REPO),)
REPO := $(shell git remote get-url origin 2>/dev/null | sed -E 's|\.git$$||; s|.*[:/]([^/]+/[^/]+)$$|\1|')
endif

PARAMETERS_DIR := parameters/$(ENVIRONMENT)
ACCOUNT_ID_VARIABLE := $(shell echo '$(ENVIRONMENT)' | tr 'a-z-' 'A-Z_')_AWS_ACCOUNT_ID
CAPABILITIES := CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
VENV := .venv

# A stack is named after its template file, so templates/network.yml deploys the stack "network".
template_file = $(or $(firstword $(wildcard $(addprefix templates/$(1),.yml .yaml .json))),$(error No template found for stack '$(1)' in templates/))
param_file = $(firstword $(wildcard $(addprefix $(PARAMETERS_DIR)/$(1),.yml .yaml .json)))

# yq expression that turns the Parameters and Tags maps of a parameter file into shell-quoted deploy flags.
CONFIG_FLAGS := [(.Parameters // {} | to_entries | map(.key + "=" + (.value | tostring) | @sh) | select(length > 0) | ["--parameter-overrides"] + .), (.Tags // {} | to_entries | map(.key + "=" + (.value | tostring) | @sh) | select(length > 0) | ["--tags"] + .)] | flatten | join(" ")

# Shell snippets used by the stack recipes below.
load_config = flags="$$($(if $(call param_file,$(1)),yq '$(CONFIG_FLAGS)' $(call param_file,$(1))))" && eval "set -- $$flags"
deploy_cmd = aws cloudformation deploy --template-file $(call template_file,$(1)) --stack-name $(1) --capabilities $(CAPABILITIES) --no-fail-on-empty-changeset "$$@"
stack_status = aws cloudformation describe-stacks --stack-name $(1) --query 'Stacks[0].StackStatus' --output text 2>/dev/null || true
failed_events = echo "Recent failed events for $(1):" >&2; aws cloudformation describe-stack-events --stack-name $(1) --query "StackEvents[?ends_with(ResourceStatus, 'FAILED')] | [:10].[LogicalResourceId, ResourceStatus, ResourceStatusReason]" --output table >&2 || true

.PHONY: help install lint deploy diff status preflight init new-stack

help: ## Show this help
	@echo "Usage: make <command> [ENVIRONMENT=<env>] [STACKS=\"<stack> ...\"]"
	@echo
	@awk 'BEGIN {FS = ":.*## "} /^[a-z%-]+:.*## / {sub(/%/, "<stack>", $$1); printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo
	@echo "Stacks: $(STACKS)"

install: $(VENV)/.installed ## Install cfn-lint and checkov into .venv

$(VENV)/.installed: requirements.txt
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install --quiet -r requirements.txt
	@touch $@

lint: install ## Lint all templates with cfn-lint and checkov
	$(VENV)/bin/cfn-lint $(TEMPLATE_FILES)
	$(VENV)/bin/checkov --config-file .checkov.yml --quiet --compact

preflight:
	@command -v aws >/dev/null || { echo "Error: the AWS CLI is required: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html" >&2; exit 1; }
	@command -v yq >/dev/null || { echo "Error: yq is required: https://github.com/mikefarah/yq#install" >&2; exit 1; }
	@test -n "$(ENVIRONMENT)" || { echo "Error: set ENVIRONMENT, for example: make $(firstword $(MAKECMDGOALS)) ENVIRONMENT=test" >&2; exit 1; }
	@test -d "$(PARAMETERS_DIR)" || { echo "Error: $(PARAMETERS_DIR) not found. Create it with: make init ENVIRONMENT=$(ENVIRONMENT)" >&2; exit 1; }
	@echo "Environment $(ENVIRONMENT), AWS account $$(aws sts get-caller-identity --query Account --output text)"

deploy: $(addprefix deploy-,$(STACKS)) ## Deploy all stacks

deploy-%: preflight ## Deploy one stack
	@echo "==> Deploying $*"
	@if [ "$$($(call stack_status,$*))" = ROLLBACK_COMPLETE ]; then \
		echo "Stack $* failed to create earlier. Deleting it before deploying again."; \
		aws cloudformation delete-stack --stack-name $* && \
		aws cloudformation wait stack-delete-complete --stack-name $*; \
	fi
	@$(call load_config,$*) && { $(call deploy_cmd,$*) || { $(call failed_events,$*); exit 1; }; }

diff: $(addprefix diff-,$(STACKS)) ## Preview the changes a deploy would make to all stacks

diff-%: preflight ## Preview the changes a deploy would make to one stack
	@echo "==> Changes for $*"
	@set -e; $(call load_config,$*); \
	output="$$($(call deploy_cmd,$*) --no-execute-changeset)"; \
	change_set="$$(sed -n 's/.*--change-set-name //p' <<<"$$output")"; \
	if [ -z "$$change_set" ]; then echo "No changes."; exit 0; fi; \
	aws cloudformation describe-change-set --change-set-name "$$change_set" --output table \
		--query 'Changes[].ResourceChange.{Action: Action, LogicalId: LogicalResourceId, Type: ResourceType, Replacement: Replacement}'; \
	aws cloudformation delete-change-set --change-set-name "$$change_set"; \
	if [ "$$($(call stack_status,$*))" = REVIEW_IN_PROGRESS ]; then aws cloudformation delete-stack --stack-name $*; fi

status: ## Show the status of all stacks in the current AWS account
	@for stack in $(STACKS); do \
		status="$$($(call stack_status,$$stack))"; \
		printf '%-30s %s\n' "$$stack" "$${status:-NOT_DEPLOYED}"; \
	done

outputs-%: ## Show the outputs of one stack
	@aws cloudformation describe-stacks --stack-name $* --output table \
		--query 'Stacks[0].Outputs[].{Key: OutputKey, Value: OutputValue}'

delete-%: ## Delete one stack after typing its name to confirm
	@account="$$(aws sts get-caller-identity --query Account --output text)" && \
	read -r -p "Type '$*' to delete this stack from AWS account $$account: " answer && \
	[ "$$answer" = "$*" ] || { echo "Aborted."; exit 1; }
	aws cloudformation delete-stack --stack-name $*
	aws cloudformation wait stack-delete-complete --stack-name $*
	@echo "Deleted $*"

init: ## Create parameters/<env> and its deploy workflow (ENVIRONMENT=<env>, optional REPO=owner/repo)
	@echo '$(ENVIRONMENT)' | grep -Eq '^[a-z][a-z0-9-]*$$' || { echo "Error: set ENVIRONMENT to a lowercase name, for example: make init ENVIRONMENT=test" >&2; exit 1; }
	@echo '$(REPO)' | grep -Eq '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$$' || { echo "Error: could not detect the GitHub repository. Set REPO=owner/repo" >&2; exit 1; }
	@mkdir -p $(PARAMETERS_DIR)
	@file=$(PARAMETERS_DIR)/oidc-provider.yml; \
	if [ -e $$file ]; then echo "Skipped $$file: already exists"; else printf '%s\n' "$$OIDC_PARAMETERS" > $$file && echo "Created $$file"; fi
	@file=.github/workflows/cloudformation-deploy-$(ENVIRONMENT).yml; \
	if [ -e $$file ]; then echo "Skipped $$file: already exists"; else printf '%s\n' "$$DEPLOY_WORKFLOW" > $$file && echo "Created $$file"; fi
	@echo
	@echo "Next steps:"
	@echo "  1. Deploy the GitHub OIDC role with credentials for this account: make deploy-oidc-provider ENVIRONMENT=$(ENVIRONMENT)"
	@echo "  2. Add the GitHub Actions variables $(ACCOUNT_ID_VARIABLE) and AWS_REGION to $(REPO)"

new-stack: ## Create a template and a parameter file per environment (NAME=<stack>)
	@echo '$(NAME)' | grep -Eq '^[a-zA-Z][a-zA-Z0-9-]*$$' || { echo "Error: set NAME to a stack name, for example: make new-stack NAME=network" >&2; exit 1; }
	@test -z "$(wildcard templates/$(NAME).*)" || { echo "Error: a template for $(NAME) already exists in templates/" >&2; exit 1; }
	@printf '%s\n' "$$STACK_TEMPLATE" > templates/$(NAME).yml && echo "Created templates/$(NAME).yml"
	@for dir in parameters/*/; do \
		printf '%s\n' "$$STACK_PARAMETERS" > "$${dir}$(NAME).yml" && echo "Created $${dir}$(NAME).yml"; \
	done

define OIDC_PARAMETERS
Parameters:
  # Lets GitHub Actions in this repository assume the deploy role in this AWS account.
  SubjectClaimFilters: "repo:$(REPO):*"
Tags:
  Project: GitHubActions
endef
export OIDC_PARAMETERS

define DEPLOY_WORKFLOW
name: Deploy $(ENVIRONMENT)

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  deploy:
    uses: ./.github/workflows/cloudformation-deploy.yml
    permissions:
      id-token: write
      contents: read
    with:
      environment: $(ENVIRONMENT)
      aws-account-id: $${{ vars.$(ACCOUNT_ID_VARIABLE) }}
endef
export DEPLOY_WORKFLOW

define STACK_TEMPLATE
AWSTemplateFormatVersion: "2010-09-09"
Description: Describe what this stack creates.

Resources:
  # Replace this placeholder with your resources.
  Placeholder:
    Type: AWS::CloudFormation::WaitConditionHandle
endef
export STACK_TEMPLATE

define STACK_PARAMETERS
# Values for the template's parameters in this environment.
Parameters: {}
# Tags that CloudFormation adds to the stack and its resources.
Tags: {}
endef
export STACK_PARAMETERS
