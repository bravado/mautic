DOCKER_IMAGE ?= bravado/mautic
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_TAG ?= $(DOCKER_IMAGE):$(GIT_BRANCH)

.PHONY: build run
default: build

build:
	docker build --cache-from ${DOCKER_TAG} -t ${DOCKER_TAG} .

run: PUID=1000
run: PGID=1000
run: USER=app
run:
	docker run -it --user=${USER} --rm -e PUID=${PUID} -e PGID=${PGID} ${DOCKER_TAG} ${CMD}
