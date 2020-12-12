include .env
export

add_test_src_to_bashrc:
	echo ". ${INSTALLATION_DIR}/tests/test_src.bash" >> "${BASHRC_FILEPATH}"

build_docker:
	docker build -t encrypted:latest --build-arg USER=${USER} .

get_into_docker:
	docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" encrypted:latest

test:
	echo $USER
