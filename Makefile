SHELL := /bin/bash

include ./docker/.env

help: ## Ayudita.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

__delete_links:
	@cd docker && rm -f docker-compose.yml && cd .. && rm -f ./IS-IN-MODE-*

__set_dev_links:
	@cd docker && ln -s docker-compose-dev.yml docker-compose.yml && cd .. && touch IS-IN-MODE-DEV

__set_prod_links:
	@cd docker && ln -s docker-compose-prod.yml docker-compose.yml && cd .. && touch IS-IN-MODE-PROD

dev: ## cambia los links a modo dev
dev: __delete_links __set_dev_links

prod: ## cambia los links a modo prod
prod: __delete_links __set_prod_links

RESET: ## Borra la base de datos y redis
	@rm -R -f volumes/db-data-psql
	@rm -R -f volumes/redis
	@rm -R -f volumes/static

start: ## docker-compose start
	@cd docker && docker-compose start

stop: ## docker-compose stop
	@cd docker && docker-compose stop

up: ## docker-compose up (with docker-compose-traefik.yml)
	@cd docker && @[ -f docker-compose-traefik.yml ] docker-compose -f docker-compose.yml -f docker-compose-traefik.yml up || docker-compose up

up_build: ## docker-compose up --build
	@cd docker && docker-compose build 
	@cd docker && [ -f docker-compose-traefik.yml ] docker-compose -f docker-compose.yml -f docker-compose-traefik.yml up || docker-compose up

down: ## docker-compose down
	@cd docker && docker-compose down > /dev/null

log: ## docker-compose logs -f --tail=1000
	@cd docker && docker-compose logs -f --tail=1000

ps: ## docker-compose ps
	@cd docker && docker-compose ps

django_bash: ## Bash en contenedor django como user django
	@docker exec -u django -ti ${CONTAINER_NAME}_django bash

django_bash_root: ## Bash en contenedor django como user root
	@docker exec -u root -ti ${CONTAINER_NAME}_django bash

django_shell: ## Shell django en el contenedor de django
	@docker exec -u django -ti ${CONTAINER_NAME}_django /srv/project/manage.py shell

django_jupyter: ## Inicia instancia de jupyter
	@docker exec -u django -ti ${CONTAINER_NAME}_django /srv/project/manage.py shell_plus --notebook

django_create_superuser: ## manage.py createsuperuser en contenedor de django
	@docker exec -u root -ti ${CONTAINER_NAME}_django /srv/project/manage.py createsuperuser

django_git_pull: ## volumes/django/git pull
	@git -C ./volumes/django pull

django_git_pull_force: ## volumes/django/git pull --force
	@git -C ./volumes/django pull

django_git_reset: ## volumes/django/git reset --hard origin/master
	@git -C ./volumes/django reset --hard origin/master

django_migrations_remove: ## Borrar los ficheros migrations de todos los modelos de django
	@sudo find . -path "./volumes/django/apps/migrations/*.py" -not -name "__init__.py" -delete
	@sudo find . -path "./volumes/django/apps/migrations/*.pyc" -delete

django_migrations_start: ## Crear migrations --fake-inital
	@docker exec -u root -ti ${CONTAINER_NAME}_django bash auto_start_migrate/start_migrates.sh

django_graph_models:  ## Crear fichero myapp_models.png con la relación de modelos
	@docker exec -u root -ti ${CONTAINER_NAME}_django /srv/project/manage.py graph_models -a -o /srv/project/myapp_models.png

psql_bash: ## Bash en contenedor postgresql como user postgres
	@docker exec -u postgres -ti ${CONTAINER_NAME}_db bash

psql_shell: ## Bash en contenedor postgresql como user postgres
	@docker exec -u postgres -ti ${CONTAINER_NAME}_db psql

psql_backup: ## Backup de postgerss (tar.gz)
	@sudo tar cvfz ./db.tar.gz ./volumes/db-data-psql

redis_bash: ## Bash en contenedor redis como user root
	@docker exec -u root -ti ${CONTAINER_NAME}_redis bash

redis_monitor: ## Bash Monitor
	@docker exec -u root -ti ${CONTAINER_NAME}_redis redis-cli monitor

redis_clear: ## Redish borrar cache en volumes/redis/*
	@docker exec -u root -ti ${CONTAINER_NAME}_redis redis-cli FLUSHALL
	@echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	@echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	@echo "Reinicia este docker, a veces la cache de redis persiste en la ram"
	@echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	@echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

fix_folders_permissions: ## Arreglar permisos en carpetas
	sudo chown ${USER} -R ./volumes/django
	sudo find ./volumes/django -type d -exec chmod 775 {} \;
	sudo find ./volumes/django -type f -exec chmod 674 {} \;
	sudo find ./volumes/django -type d -name \* -exec chmod 775 {} \;
	sudo find ./volumes/django -type f -iname "*.sh" -exec chmod 777 {} \;
	sudo find ./volumes/django -type f -iname "manage.py" -exec chmod 777 {} \;
	@echo ""
	@echo "es aconsejable hacer chown {tu_user} -R ./volumes/django"
