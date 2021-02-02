#!/usr/bin/env bats
load ../import_helpers
load_src install/docker

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "test real install docker" {
    assert_dir_not_exist "$SYSTEM_DIR/docker"
    run check_docker
    assert_failure

    cmd_set install_docker >&3 2>&3

    command -v docker
    assert_dir_exist "$SYSTEM_DIR/docker"
    local actual_data_root
    actual_data_root=$(sudo docker info 2>/dev/null | grep "Docker Root Dir" | awk '(NR == 1){print $4}')
    echo "$actual_data_root $SYSTEM_DIR/docker" >&3
    assert_equal "$actual_data_root" "$SYSTEM_DIR/docker"
    sudo runuser -l "$USER" -c "docker run hello-world"
    check_docker
}