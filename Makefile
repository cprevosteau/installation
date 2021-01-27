include env/.env*
export
SHELL := /bin/bash
CURRENT_DIR := $(shell pwd)
SUPPORTED_COMMANDS := build_docker_with
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMAND_ARGS):;@:)
endif
ENCRYPTED_IMAGE := registry.gitlab.com/cprevosteau/installation/encrypted

add_test_src_to_bashrc:
	echo ". ${INSTALLATION_DIR}/tests/test_src.bash" >> "${BASHRC_FILEPATH}"

build_docker:
	docker build -t registry.gitlab.com/cprevosteau/installation/encrypted --build-arg TESTS_DIR=${TESTS_DIR} --build-arg USER=${USER} .
	docker push registry.gitlab.com/cprevosteau/installation/encrypted

build_docker_with:
	# COMMAND_ARGS is java, docker or systemd
	docker build -t registry.gitlab.com/cprevosteau/installation/encrypted/$(COMMAND_ARGS) -f dockers/encrypted_with_$(COMMAND_ARGS).Dockerfile .
	docker push registry.gitlab.com/cprevosteau/installation/encrypted/$(COMMAND_ARGS)

build_dockers:
	make build_docker
	make build_docker_with java
	make build_docker_with systemd
	make build_docker_with docker

set_normal_data_root:
	source "src/utils/import_src_and_env.bash" && import_src_and_env \
		&& source "tests/test_helpers/helpers/src/change_docker.bash" && set_normal_data_root

set_encrypted_data_root:
	source "src/utils/import_src_and_env.bash" && import_src_and_env \
		&& source "tests/test_helpers/helpers/src/change_docker.bash" && set_encrypted_data_root

run_systemd_docker:
	make test_real_install_docker

get_into_docker:
	docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" -v "${DATA_DIR}:${DATA_DIR}" $(ENCRYPTED_IMAGE) bash -i

get_into_last_docker:
	docker start -a -i `docker ps -q -l`

tests_in_docker:
	docker run --privileged -tv "${CURRENT_DIR}:${INSTALLATION_DIR}:ro" $(ENCRYPTED_IMAGE)

tests_in_docker_tap:
	docker run -itv "${CURRENT_DIR}:${INSTALLATION_DIR}:ro" $(ENCRYPTED_IMAGE) bats -r --tap "${TESTS_DIR}/src"

install_bats_and_add_ons:
	git submodule add https://github.com/bats-core/bats-support tests/test_helpers/bats-support
	git submodule add https://github.com/bats-core/bats-assert tests/test_helpers/bats-assert
	git submodule add https://github.com/bats-core/bats-file tests/test_helpers/bats-file

test_helpers:
	docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" $(ENCRYPTED_IMAGE) bats -r "${TESTS_DIR}/test_helpers/helpers"

test_real_install_docker:
	make set_normal_data_root
	mkdir -p /tmp/archives
	docker stop systemd || true
	docker rm systemd || true
	make build_docker_with_systemd
	docker run --runtime=sysbox-runc --name=systemd -v "/tmp/archives:/var/cache/apt/archives" -t encrypted_with_systemd > /dev/null 2>&1 &
	sleep 1
	docker exec -tiu clement systemd bats "${TESTS_DIR}/real_install/docker.bats" --tap

test_set_data_root_directory:
	make set_normal_data_root
	mkdir -p /tmp/archives
	docker stop docker || true
	docker rm docker || true
	make build_docker_with_docker
	docker run --runtime=sysbox-runc --name=docker -v "/tmp/archives:/var/cache/apt/archives" -t encrypted_with_docker > /dev/null 2>&1 &
	sleep 1
	docker exec -tiu clement docker bats "${TESTS_DIR}/real_install/set_data_root_directory.bats" --tap

test_real_install_biglybt:
	docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" -v "${DATA_DIR}:${DATA_DIR}" encrypted_with_java:latest bats "${TESTS_DIR}/real_install/biglybt.bats" --tap

install_sysbox:
	wget -c https://github.com/nestybox/sysbox/releases/download/v0.2.1/sysbox_0.2.1-0.ubuntu-focal_amd64.deb
	sha256sum sysbox_0.2.1-0.ubuntu-focal_amd64.deb | grep 126e4963755cdca440579d81409b3f4a6d6ef4c6c2d4cf435052a13468e2c250
	docker rm $(shell docker ps -a -q) -f || true
	sudo apt-get install ./sysbox_0.2.1-0.ubuntu-focal_amd64.deb -y && rm sysbox_0.2.1-0.ubuntu-focal_amd64.deb

login_to_docker_repo:
	pass Perso/Gitlab | docker login --username=cprevosteau --password-stdin registry.gitlab.com

test_ci_cd:
	sudo gitlab-runner exec docker test_with_docker --docker-privileged