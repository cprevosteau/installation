#!/usr/bin/env bats
load ../import_helpers
load_src install/slack

setup() {
    # executed before each test
    echo "setup" >&3
    mock_download_func_to_use_stored_data download_file
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "test_slack" {
    run check_slack
    assert_failure

    cmd_set install_slack 1>&3
    command -v slack
    check_slack
}