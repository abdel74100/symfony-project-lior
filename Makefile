# Variables
DOCKER = docker
DOCKER_COMPOSE = docker-compose
# Définir le nom du service ou conteneur Docker. Ici, nous utilisons le nom du conteneur.
CONTAINER_NAME = cours-ecommerce_symshop_1
# Exécuter des commandes à l'intérieur du conteneur avec le répertoire de travail correct.
EXEC = $(DOCKER) exec -w /var/www $(CONTAINER_NAME)
PHP = $(EXEC) php
COMPOSER = $(EXEC) composer
NPM = $(EXEC) npm
SYMFONY_CONSOLE = $(PHP) bin/console


# Colors - Use echo with a shell command in Makefile
define GREEN
	@echo "\033[32m## $1\033[0m"
endef

define RED
	@echo "\033[31m## $1\033[0m"
endef

## —— 🔥 App ——
init: ## Init the project
	$(MAKE) start
	$(MAKE) composer-install
	$(MAKE) npm-install
	$(call GREEN,"The application is available at: http://127.0.0.1:9000/.")

cache-clear: ## Clear cache
	$(SYMFONY_CONSOLE) cache:clear

## —— ✅ Test ——
.PHONY: tests
tests: ## Run all tests
	$(MAKE) database-init-test
	$(PHP) bin/phpunit --testdox tests/Unit/
	$(PHP) bin/phpunit --testdox tests/Functional/
	$(PHP) bin/phpunit --testdox tests/E2E/

database-init-test: ## Init database for test
	$(SYMFONY_CONSOLE) doctrine:database:drop --force --if-exists --env=test
	$(SYMFONY_CONSOLE) doctrine:database:create --env=test
	$(SYMFONY_CONSOLE) doctrine:migrations:migrate --no-interaction --env=test
	$(SYMFONY_CONSOLE) doctrine:fixtures:load --no-interaction --env=test

unit-test: ## Run unit tests
	$(MAKE) database-init-test
	$(PHP) bin/phpunit --testdox tests/Unit/

functional-test: ## Run functional tests
	$(MAKE) database-init-test
	$(PHP) bin/phpunit --testdox tests/Functional/

e2e-test: ## Run E2E tests
	$(MAKE) database-init-test
	$(PHP) bin/phpunit --testdox tests/E2E/

## —— 🐳 Docker ——
start: ## Start app
	$(MAKE) docker-start
docker-start:
	$(DOCKER_COMPOSE) up -d

stop: ## Stop app
	$(MAKE) docker-stop
docker-stop:
	$(DOCKER_COMPOSE) stop
	$(call RED,"The containers are now stopped.")

## —— 🎻 Composer ——
composer-install: ## Install dependencies
	$(COMPOSER) install

composer-update: ## Update dependencies
	$(COMPOSER) update

## —— 🐈 NPM ——
npm-install: ## Install all npm dependencies
	$(NPM) install

npm-update: ## Update all npm dependencies
	$(NPM) update

npm-watch: ## Run npm in watch mode
	$(NPM) run watch

## —— 📊 Database ——
database-init: ## Init database
	$(MAKE) database-drop
	$(MAKE) database-create
	$(MAKE) database-migrate
	$(MAKE) database-fixtures-load

database-drop: ## Drop database
	$(SYMFONY_CONSOLE) doctrine:database:drop --force --if-exists

database-create: ## Create database
	$(SYMFONY_CONSOLE) doctrine:database:create --if-not-exists

database-migration: ## Make migration
	$(SYMFONY_CONSOLE) make:migration

migration: ## Alias for database-migration
	$(MAKE) database-migration

database-migrate: ## Migrate migrations
	$(SYMFONY_CONSOLE) doctrine:migrations:migrate --no-interaction

migrate: ## Alias for database-migrate
	$(MAKE) database-migrate

database-fixtures-load: ## Load fixtures to the database
	$(SYMFONY_CONSOLE) doctrine:fixtures:load --no-interaction

## —— 🖥️ Shell ——
bash: ## Open bash shell in the app container
	$(DOCKER) exec -it $(CONTAINER_NAME) /bin/bash
