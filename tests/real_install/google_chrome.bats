#!/usr/bin/env bats
load ../import_helpers
load_src install/google_chrome

setup() {
    # executed before each test
    echo "setup" >&3

}
teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "google_chrome" {
    run check_google_chrome
    assert_failure

    cmd_set install_google_chrome 1>&3 2>&3
    command -v google-chrome
    check_google_chrome
}
