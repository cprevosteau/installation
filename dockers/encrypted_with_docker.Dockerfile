ARG VERSION
FROM registry.gitlab.com/cprevosteau/installation/encrypted/systemd
SHELL ["/bin/bash", "-c"]
RUN source "$TESTS_DIR/../src/utils/import_src_and_env.bash" && import_src_and_env && \
    load install/docker.bash && \
    remove_old_docker_install && \
    install_docker_package && \
    add_user_to_docker_group
COPY . $TESTS_DIR/../