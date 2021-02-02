#!/usr/bin/env bats
load '../import_helpers'

setup() {
    # executed before each test
    echo "setup" >&3
    load_src install/bats
    bats_file="/usr/local/bin/bats"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "install_bats" {
    run check_bats
    assert_failure

    cmd_set install_bats 2>&3

    command -v bats
    assert_dir_exist "${APP_DIR}/bats-core"
    assert_file_exist "${bats_file}"
    check_bats
}