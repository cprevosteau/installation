#!/usr/bin/env bats
load ../import_helpers
load_src install/poetry

setup() {
    # executed before each test
    echo "setup" >&3
    mock_download_func_to_use_stored_data download_stream
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "real installation poetry" {
    sudo apt install -y python3.8
    sudo ln -s "$(which python3.8)"  /usr/bin/python
    run check_poetry
    assert_failure

    cmd_set install_poetry 1>&3 2>&3
    assert_dir_exist "$POETRY_DIR"
    env -i HOME="$HOME" bash -lc "command -v poetry"
    check_poetry
}
