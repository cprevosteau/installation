#!/usr/bin/env bats
load ../import_helpers
load_src install/biglybt/biglybt

setup() {
    # executed before each test
    echo "setup" >&3
    skip_if_not_in_docker
    mock_download_func_to_use_stored_data download_file
    local tmp_biglybt_installer="/tmp/BiglyBT_Installer.sh"
    mkdir "$HOME/.biglybt"
    touch "$HOME/.biglybt/biglybt.config"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    [ ! -f "$tmp_biglybt_installer" ] || rm "$tmp_biglybt_installer"
    [ ! -d "$APP_DIR/biglybt" ] || rm -r "$APP_DIR/biglybt"
}

@test "real install biglybt" {
    run check_biglybt
    assert_failure

    cmd_set install_biglybt 2>&3 1>&3

    assert_dir_exist "$APP_DIR/biglybt"
    assert_file_exist "$APP_DIR/biglybt/biglybt"
    assert_file_not_exist "/tmp/BiglyBT_Installer.sh"
    check_biglybt
}