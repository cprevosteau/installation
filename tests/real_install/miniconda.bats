#!/usr/bin/env bats
load ../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    load_src install/miniconda

}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "real installation miniconda" {
    run_set install_miniconda 2>&3 1>&3
    assert_dir_exist "${MINICONDA_DIR}"
    cat "${HOME}/.bashrc"
    command -v jupyter
    env -i bash -c "command -v conda"
}