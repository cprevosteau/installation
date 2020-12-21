#!/usr/bin/env bats
load ../import_helpers
load_src install/miniconda


setup() {
    # executed before each test
    echo "setup" >&3
    mock_download_func_to_use_stored_data download_file
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "real installation miniconda" {
    cmd_set install_miniconda 2>&3
    assert_dir_exist "${MINICONDA_DIR}"
    command -v jupyter
    env -i bash -ic "command -v conda"
}