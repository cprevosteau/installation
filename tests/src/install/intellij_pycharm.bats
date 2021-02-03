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

@test "Test intellij (Is link active ?)" {
    download_extract_to_dir() {
      local url="${1}"
      local output_directory="${2}"
      download_status_code_to_file "${url}" "${intellij_file}"
      echo "${output_directory}"
    }
    config_jetbrains() {
      echo "config_jetbrains"
    }
    run install_intellij >&3 2>&3

    assert_success
    assert_file_exist "${intellij_file}"
    assert_equal "$(cat "${intellij_file}")" 200
    assert_equal "${lines[0]}" "${APP_DIR}"
    assert_equal "${lines[1]}" "config_jetbrains"
}

@test "Test pycharm (Is link active ?)" {
    download_extract_to_dir() {
      local url="${1}"
      local output_directory="${2}"
      download_status_code_to_file "${url}" "${pycharm_file}"
      echo "${output_directory}"
    }
    config_jetbrains() {
      echo "config_jetbrains"
    }
    run install_pycharm >&3 2>&3

    assert_success
    assert_file_exist "${pycharm_file}"
    assert_equal "$(cat "${pycharm_file}")" 200
    assert_equal "${lines[0]}" "${APP_DIR}"
    assert_equal "${lines[1]}" "config_jetbrains"
}

@test "config_jetbrains" {
    run checker check_config_jetbrains
    assert_failure
    config_jetbrains
    checker check_config_jetbrains
}
