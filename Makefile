DOCKER_COMPOSE ?= ./.deploy/docker/docker-compose.yml
DOCKER_FILE ?= ./.deploy/docker/sdk.Dockerfile
K8_BUILD_DIR ?= ./.deploy/k8
DOCKER_IMAGE ?= lthn/sdk-shell

SHELL_EXPORT := $(foreach v,$(MAKE_ENV),$(v)='$($(v))' )

.PHONY: k8
k8:
	@mkdir -p $(K8_BUILD_DIR)
	kompose convert --file "$(DOCKER_COMPOSE)" --out "$(K8_BUILD_DIR)"

.PHONY: docker
docker:
	docker build --no-cache -f "$(DOCKER_FILE)" -t "$(DOCKER_IMAGE)" .

.PHONY: deploy-docker
deploy-docker: docker
	docker push "$(DOCKER_IMAGE)"

.PHONY: run-docker
run-docker: docker
	docker run -it "$(DOCKER_IMAGE)" bash

# to eject, we have to get the image, run it, cp, stop it.
.PHONY: update-docker
update-docker: eject-docker-cp
	echo "Stopping: " && docker stop "sdk-shell" && echo "Deleting:" && docker container rm "sdk-shell"

# get docker image
.PHONY: pull-docker
pull-docker:
	docker pull "$(DOCKER_IMAGE)"

# export the files to the current directory
.PHONY: eject-docker-cp
eject-docker-cp: pull-docker
	docker run  --name="sdk-shell" -d "$(DOCKER_IMAGE)" && docker cp sdk-shell:/home/lthn/ ../../

.PHONY: eject-docker-cp
clean-docker:
	docker system prune


.PHONY: install
install:
	ln -s "$(pwd)"/lthn.sh /usr/bin/lthn && chmod +x /usr/bin/lthn




.PHONY: build-k8s
build-k8s: $(K8_BUILD_DIR)
	@for file in $(K8S_FILES); do \
		mkdir -p `dirname "$(K8_BUILD_DIR)/$$file"` ; \
		$(SHELL_EXPORT) envsubst <$(DOCKER_COMPOSE)/$$file >$(K8_BUILD_DIR)/$$file ;\
	done

.PHONY: deploy
deploy: build-k8s build-docker
	kubectl apply -f $(K8_BUILD_DIR)