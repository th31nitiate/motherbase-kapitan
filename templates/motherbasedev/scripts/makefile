.DEFAULT_GOAL := help

{% for item in inventory.parameters.compose.services %}
.PHONY: {{item}}_up
compose_{{item}}:
	docker-compose -f {{item}}.yml up

.PHONY: {{item}}_down
{{item}}_down:
	docker-compose -f {{item}}.yml down
	
{% endfor %}

{% if inventory.parameters.compose.services.saltenv is defined%}

.PHONY: compose_saltenv_data
compose_saltenv_data:
	docker-compose -f saltenv.yml -f dataplane.yml up

.PHONY: compose_saltenv_down
compose_saltenv_down:
	docker-compose -f saltenv.yml -f dataplane.yml down

{% if inventory.parameters.compose.services.saltenv is defined%}
.PHONY: saltenv_hashi_up
saltenv_hashi_up:
	docker-compose -f saltenv.yml -f dataplane.yml -f hashicorp.yml up

.PHONY: saltenv_hashi_down
saltenv_hashi_down:
	docker-compose -f saltenv.yml -f dataplane.yml -f hashicorp.yml down

{% endif %}
{% endif %}