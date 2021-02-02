#!/usr/bin/env bats
load ../import_helpers
load_src install/system

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "test_system" {
    run check_system
    assert_failure

    cmd_set install_system 1>&3
    check_system
}