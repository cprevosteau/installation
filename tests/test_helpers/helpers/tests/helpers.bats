#!/usr/bin/env bats
load ../../../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "add_cmd_to_func_def" {
    # Given
    local test_output_val="Output"
    func_test() {
        echo "$output"
    }
    local func_test_def expected_new_func_def new_func_def
    func_test_def=$(declare -f func_test)
    local lines_to_add=( "local output=$test_output_val" 'echo "all is ok"' )
    expected_new_func_def=$(echo -e "func_test () \n{ local output=Output; echo \"all is ok\"; \n    echo \"\$output\"\n}")

    # When
    new_func_def=$(cmd_set add_cmd_to_func_def "$func_test_def" "${lines_to_add[@]}")

    # Then
    assert_equal "$new_func_def" "$expected_new_func_def"
}

@test "save_function" {
    # Given
    local test_var="doit être affiché"
    func_test() {
        echo "$test_var"
    }
    # When
    cmd_set save_function func_test new_func_test "test_var=\"$test_var\""
    unset test_var
    output_new_func=$(new_func_test)
    output_old_func=$(func_test)

    # Then
    assert_equal "$output_new_func" "doit être affiché"
    assert_equal "$output_old_func" ""
}

@test "assert_valid_json_if_valid" {
    local valid_json_file="/tmp/valid.json"
    cat <<EOF > "$valid_json_file"
{
    "status": "good_json",
    "ok": "ok"
}
EOF
    run_set assert_valid_json "$valid_json_file"
    assert_success
}

@test "assert_valid_json_if_not_valid" {
    local not_valid_json_file="/tmp/valid.json"
    cat <<EOF > "$not_valid_json_file"
{
    "status": "good_json"
    "ok": "ok"
}
EOF
    run_set assert_valid_json "$not_valid_json_file"
    assert_failure
}