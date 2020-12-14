#!/usr/bin/env bats
load ../../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    tmp_file="status_code_file"
    url="https://www.google.com"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    rm "${tmp_file}"
}

@test "test download_status_code_to_file" {
    run_set download_status_code_to_file "${url}" "${tmp_file}"
    assert_file_exist "${tmp_file}"
    [ "$(cat ${tmp_file})" -eq 200 ]
}

@test "test download_status_code_to_stream" {
    run_set download_status_code_to_stream "${url}" >"${tmp_file}"
    assert_file_exist "${tmp_file}"
    [ "$(cat ${tmp_file})" -eq 200 ]
}