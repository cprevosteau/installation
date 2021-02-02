#!/usr/bin/env bats
load ../import_helpers
load_src install/pyenv

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "install_pyenv" {
    assert_dir_not_exist "$PYENV_DIR"
    run check_pyenv
    assert_failure

    cmd_set install_pyenv 1>&3 2>&3

    assert_dir_exist "$PYENV_DIR"
    env -i bash -ic "command -v pyenv"
    check_pyenv
}
