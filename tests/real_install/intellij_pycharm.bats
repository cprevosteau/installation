#!/usr/bin/env bats
load ../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    load_src install/intellij_pycharm
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "real install intellij pycharm" {
    mock_download_func download_stream
    run_set install_intellij_pycharm
    assert_file_exist "${APP_DIR}"/idea*/bin/idea.sh
    assert_file_exist "${APP_DIR}"/pycharm*/bin/pycharm.sh
    assert_symlink_to "${SYSTEM_DIR}/config/JetBrains" "${CONFIG_DIR}/JetBrains"
}