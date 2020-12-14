include env/.env*
export

add_test_src_to_bashrc:
	echo ". ${INSTALLATION_DIR}/tests/test_src.bash" >> "${BASHRC_FILEPATH}"

build_docker:
	docker build -t encrypted:latest --build-arg TESTS_DIR=${TESTS_DIR} --build-arg USER=${USER} .

get_into_docker:
	docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" encrypted:latest bash -i

tests_in_docker:
	docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" encrypted:latest

install_bats_and_add_ons:
	git submodule add https://github.com/bats-core/bats-support tests/test_helpers/bats-support
	git submodule add https://github.com/bats-core/bats-assert tests/test_helpers/bats-assert
	git submodule add https://github.com/bats-core/bats-file tests/test_helpers/bats-file