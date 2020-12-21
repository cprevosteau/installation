#!/usr/bin/env bats
load ../../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    load_src install/intellij_pycharm
    intellij_file="/tmp/intellij"
    pycharm_file="/tmp/pycharm"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "Test download intellij_pycharm (Is link active ?)" {
    next_output_file="${intellij_file}"
    download_extract_to_dir() {
      local url="${1}"
      local output_directory="${2}"
      download_status_code_to_file "${url}" "${next_output_file}"
      echo "${output_directory}"
      next_output_file="${pycharm_file}"
    }
    config_intellij_pycharm() {
      echo "config_intellij_pycharm"
    }
    run_set install_intellij_pycharm >&3 2>&3
    assert_success
    echo test intellij >&3
    assert_file_exist "${intellij_file}"
    assert_equal "$(cat "${intellij_file}")" 200
    echo test pycharm >&3
    assert_file_exist "${pycharm_file}"
    assert_equal "$(cat "${pycharm_file}")" 200
    assert_equal "${lines[0]}" "${APP_DIR}"
    assert_equal "${lines[1]}" "${APP_DIR}"
    assert_equal "${lines[2]}" "config_intellij_pycharm"
}