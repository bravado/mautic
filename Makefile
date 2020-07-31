DOCKER_IMAGE ?= bravado/mautic
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_TAG ?= $(DOCKER_IMAGE):$(shell echo ${GIT_BRANCH} | sed -e "s%^master$$%latest%" )

.PHONY: build run
default: build

build:
	docker build -t ${DOCKER_TAG} .

run: PUID=1000
run: PGID=1000
run: PORT=8082
run:
	docker run -it --name mautic --rm -v mautic:/var/www/local -e PUID=${PUID} -e PGID=${PGID} -p ${PORT}:80 --link mysql:mysql -e MAUTIC_DB_PASSWORD=root -e MAUTIC_DB_HOST=mysql:3306 ${DOCKER_TAG} ${CMD}
