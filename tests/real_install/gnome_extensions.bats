#!/usr/bin/env bats
load ../import_helpers
load_src install/gnome_extensions

setup() {
    # executed before each test
    echo "setup" >&3

}
teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "gnome_extensions" {
    run check_gnome_extensions
    assert_failure

    cmd_set install_gnome_extensions 1>&3 2>&3
    run check_gnome_extensions
    assert_success
}