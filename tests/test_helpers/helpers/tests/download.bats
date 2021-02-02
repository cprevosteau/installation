#!/usr/bin/env bats
load ../../../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    tmp_file="status_code_file"
    url="https://www.google.fr"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    [ ! -f "$tmp_file" ] || rm "${tmp_file}"
}

@test "test download_status_code_to_file" {
    cmd_set download_status_code_to_file "${url}" "${tmp_file}"
    assert_file_exist "${tmp_file}"
    assert_equal "$(cat ${tmp_file})"  "200"
}

@test "test download_status_code_to_stream" {
    # shellcheck disable=SC2155
    local output=$(cmd_set download_status_code_to_stream "${url}")
    assert_output "200"
}
