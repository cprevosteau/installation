#!/usr/bin/env bats
load '../../import_helpers'

setup() {
    # executed before each test
    echo "setup" >&3
    load_src install/bats
    bats_file="/usr/bin/bats"
    sudo mv /usr/bin/bats /tmp
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    sudo mv /tmp/bats "${bats_file}"
}

@test "install_bats" {
    run_set install_bats
    command -v bats
    assert_dir_exist "${APP_DIR}/bats-core"
    assert_file_exist "${bats_file}"
}