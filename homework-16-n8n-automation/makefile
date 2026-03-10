.PHONY: up down restart logs ps clean help

# Default target
.DEFAULT_GOAL := help

up: ## Start n8n and PostgreSQL in background
	docker compose up -d

down: ## Stop all services
	docker compose down

restart: ## Restart all services
	docker compose restart

logs: ## Follow logs (all services)
	docker compose logs -f

logs-n8n: ## Follow n8n logs only
	docker compose logs -f n8n

logs-db: ## Follow PostgreSQL logs only
	docker compose logs -f postgres

ps: ## Show running containers status
	docker compose ps

clean: ## Stop and remove containers + volumes (WARNING: deletes all data!)
	docker compose down -v

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'