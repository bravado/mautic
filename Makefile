DOCKER_IMAGE ?= bravado/mautic
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_TAG ?= $(DOCKER_IMAGE):$(shell echo ${GIT_BRANCH} | sed -e "s%^master$$%latest%" )

.PHONY: build run
default: build

build:
	docker-compose build

start:
	docker-compose up -d

stop:
	docker-compose down

purge:
	docker-compose down --volumes

shell: USER=app
shell:
	docker-compose exec --user ${USER} mautic bash

logs:
	docker-compose logs -f mautic
