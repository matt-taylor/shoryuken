.PHONY: test dev_test bundle dev
.PHONY: default build clean down ps stop help cleanall

DC_FILE?=docker-compose.yml
SERVICE?=shoryuken

default: help

build: #: Build the containers that we'll need
	docker-compose -f $(DC_FILE) build --pull

down:
	docker-compose -f $(DC_FILE) down

stop: #: Stop the running containers
	docker-compose -f $(DC_FILE) stop

ps: #: Show all currently running docker containers
	docker-compose -f $(DC_FILE) ps

help: #: Show help topics
	@grep "#:" Makefile | grep -v "@grep" | sed "s/.*:\([A-Za-z_ -]*\):.*#\(.*\)/$$(tput setaf 3)\1$$(tput sgr0)\2/g" | sort

clean: #: Clean up stopped containers
	docker-compose -f $(DC_FILE) rm -f

cleanall: clean #: Docker compose down with all volumes and networking and local image cleanup
	docker-compose -f $(DC_FILE) down -v --remove-orphans --rmi local

test: #: Run all of the tests
	docker-compose -f $(DC_FILE) run -e RAILS_ENV=test $(SERVICE) bundle exec rspec --format=documentation spec

dev_test: #: Run all of the tests, fail on first broken test
	docker-compose -f $(DC_FILE) run -e RAILS_ENV=test $(SERVICE) bundle exec rspec --format=documentation --fail-fast spec

bundle: #: Install gems
	docker-compose -f $(DC_FILE) run --rm -e RAILS_ENV=development $(SERVICE) bundle install --with=test development

bash: #: Get a bash development container
	docker-compose -f $(DC_FILE) run --rm -e RAILS_ENV=development $(SERVICE) bash

cleandev: cleanall setup_db migrate asset_precompile dev #: Restart dev enviornemnt in attached mode
