.DEFAULT_GOAL := help
SHELL := /bin/bash

# vault_1          | Unseal Key: erRKGj7Q3d3qF4RaGSkfC3NNBQVHmMezcuVVW09Su1w=
#vault_1          | Root Token: 5qNoRTSP3rR0BkSkNqn1fGwI

.PHONY: generate_manifest
generate_manifest: ## Create the terraform stack env vars
	kapitan compile
	cp compiled/motherbase-dev/docker_compose/docker_compose.yml docker-compose.yml


.PHONY: compose_up
compose_up:
	docker-compose -f docker-compose.yml up

.PHONY: compose_down
compose_down:
	docker-compose -f docker-compose.yml down
	docker-compose -f docker-compose.yml rm