DOCKER_FILE ?= Dockerfile
DOCKER_IMAGE ?= lthn/sdk-shell

SHELL_EXPORT := $(foreach v,$(MAKE_ENV),$(v)='$($(v))' )


.PHONY: build deploy run-docker install
build:
	docker build --no-cache -f "$(DOCKER_FILE)" -t "$(DOCKER_IMAGE)" .

deploy:
	docker push "$(DOCKER_IMAGE)"

run:
	docker run -it "$(DOCKER_IMAGE)" bash

install:
	ln -s "$(pwd)"/lthn.sh /usr/bin/lthn && chmod +x /usr/bin/lthn
