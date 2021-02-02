#!/usr/bin/env bats
load ../../import_helpers
load_src install/docker

setup() {
    # executed before each test
    echo "setup" >&3
    docker_daemon_file="/tmp/daemon.json"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    delete_if_file_exist "$docker_daemon_file"
}

@test "test_change_data_root_if_existing" {
    local new_path="new/path"
    cat <<EOF > "$docker_daemon_file"
{
    "a": 5,
    "data-root": "path/to/be/changed",
    "test": "this is a test"
}
EOF
    cmd_set add_string_entry_to_json "data-root" "$new_path" "$docker_daemon_file"
    assert_valid_json "$docker_daemon_file"
    assert_equal "$(jq '.["data-root"]' "$docker_daemon_file")" "\"$new_path\""
}

@test "test_add_data_root" {
    local new_path="new/path"
    cat <<EOF > "$docker_daemon_file"
{
    "a": 5,
    "test": "this is a test"
}
EOF
    cmd_set add_string_entry_to_json "data-root" "$new_path" "$docker_daemon_file"
    assert_valid_json "$docker_daemon_file"
    assert_equal "$(jq '.["data-root"]' "$docker_daemon_file")" "\"$new_path\""
}
