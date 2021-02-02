#!/usr/bin/env bats
load ../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    load_src install/intellij_pycharm
    mock_download_func_to_use_stored_data download_stream
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "real install intellij pycharm" {
    run check_intellij_pycharm
    assert_failure

    cmd_set install_intellij_pycharm 2>&3 1>&3

    assert_file_exist "${APP_DIR}"/idea*/bin/idea.sh
    assert_file_exist "${APP_DIR}"/pycharm*/bin/pycharm.sh
    assert_symlink_to "${SYSTEM_DIR}/config/JetBrains" "${CONFIG_DIR}/JetBrains"
    check_intellij_pycharm
}