#!/usr/bin/env bats
load ../../import_helpers
load_src install/poetry

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "poetry is link active ?" {
    download_stream() {
        local url="${1}"
        download_status_code_to_stream "$url"
    }
    run_set download_poetry
    assert_output "200"
}

@test "install poetry package" {
    sudo apt install -y python3.8
    sudo ln -s "$(which python3.8)"  /usr/bin/python
    local script="import os; print(os.getenv('POETRY_HOME'))"
    local expected_poetry_dir="/tmp/poetry"
    local actual_poetry_dir
    actual_poetry_dir=$(echo "$script" | cmd_set install_poetry_package "$expected_poetry_dir")
    assert_equal "$actual_poetry_dir" "$expected_poetry_dir"
}
