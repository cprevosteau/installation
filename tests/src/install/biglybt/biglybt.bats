#!/usr/bin/env bats
load ../../../import_helpers
load_src install/biglybt/biglybt

setup() {
    # executed before each test
    echo "setup" >&3
    tmp_biglybt_installer="${BATS_TMPDIR}/biglybt_status_code"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    [ ! -e "${tmp_biglybt_installer}" ] || rm "${tmp_biglybt_installer}"
    if command -v expect; then
      sudo apt remove -y expect
    fi
}

@test "Is link for biglybt installer active ?" {
    download_file() {
      local url="${1}"
      local status_code_file="$2"
      download_status_code_to_file "${url}" "$status_code_file"
    }
    cmd_set download_biglybt_installer "$tmp_biglybt_installer"
    assert_file_exist "$tmp_biglybt_installer"
    local status_code
    status_code=$(cat "$tmp_biglybt_installer")
    assert_equal "$status_code" 200
}

@test "test install expect" {
    install_expect
    command -v expect
}

@test "install_biglybt_from_installer_without_display" {
    install_expect
    local installer="$TEST_DIR/tests/install/biglybt/biglybt_fake_installer.sh"
    run install_biglybt_from_installer_without_display "$installer" "app_dir_test"
    assert_success
}