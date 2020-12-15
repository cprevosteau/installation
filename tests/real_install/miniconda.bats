#!/usr/bin/env bats
load ../import_helpers
load_src install/miniconda


setup() {
    # executed before each test
    echo "setup" >&3


}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "real installation miniconda" {
    mock_download_func download_file
    run_set install_miniconda
    assert_dir_exist "${MINICONDA_DIR}"
    cat "${HOME}/.bashrc"
    command -v jupyter
    env -i bash -c "command -v conda"
}