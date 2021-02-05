#!/usr/bin/env bats
load ../import_helpers
load_src install/explorer

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}


@test "explorer" {
    # Given
    run_set check_explorer
    assert_failure

    # When
    run_set install_explorer
    assert_success

    check_bookmarks "${ENCRYPTED_DIR}" "/"
}
