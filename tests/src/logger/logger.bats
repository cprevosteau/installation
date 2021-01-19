#!/usr/bin/env bats
load ../../import_helpers
load_src logger/logger

setup() {
    # executed before each test
    echo "setup" >&3
    log_file=/tmp/log
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    delete_if_file_exist "$log_file"
}

@test "prefix_level" {
    expected_output_rgx='\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[TEST\] test: output'

    local output
    output=$(echo 'output' | cmd_set prefix_level TEST test)

    grep -qP "$expected_output_rgx" <(echo "$output")
}

@test "run_cmd_with_log log stdin and stderr" {
    local package='test'
    expected_stdin_rgx='\[INFO\] test: info'
    expected_stderr_rgx='\[ERROR\] test: error'
    cmd_test() {
        echo "info"
        echo "error" 2>&1
    }

    cmd_set run_cmd_with_log "$log_file" "$package" cmd_test

    assert_file_exist "$log_file"
    grep -qP "$expected_stdin_rgx" "$log_file"
    grep -qP "$expected_sterr_rgx" "$log_file"

}

@test "run_cmd_with_log propagates exit code" {
    cmd_success() {
        echo "info"
        echo "error" 2>&1
        return 0
    }
    cmd_fail() {
        echo "info"
        echo "error" 2>&1
        return 1
    }

    run run_cmd_with_log "$log_file" "$package" cmd_fail
    assert_failure
    run run_cmd_with_log "$log_file" "$package" cmd_success
    assert_success

    assert_file_exist "$log_file"

}