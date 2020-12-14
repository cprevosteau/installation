#!/usr/bin/env bats
load ../../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    load_src utils/download
    tmp_file="/tmp/google"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    rm "${tmp_file}"
}

@test "test download_file" {
    run_set download_file https://www.google.com "${tmp_file}"
    assert_file_exist "${tmp_file}"
    [[ "$(awk 'NR==1' ${tmp_file})" =~ "<!doctype html>" ]]
}

@test "test download_stream" {
    run_set download_stream https://www.google.com | cat >>"${tmp_file}"
    assert_file_exist "${tmp_file}"
    [[ "$(awk 'NR==1' ${tmp_file})" =~ "<!doctype html>" ]]
}