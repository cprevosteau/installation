#!/usr/bin/env bats
load ../../import_helpers
load_src install/biglybt

setup() {
    # executed before each test
    echo "setup" >&3
    tmp_biglybt_installer="${BATS_TMPDIR}/biglybt_status_code"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    [ ! -e "${tmp_biglybt_installer}" ] || rm "${tmp_biglybt_installer}"
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

@test "test install biglybt package" {
    local expected_output="$APP_DIR/biglybt
y
2
7"
    echo "while read data; do echo \$data; done" > "$tmp_biglybt_installer"
    run_set install_biglybt_from_installer_without_display "$tmp_biglybt_installer"
    assert_success
    assert_output "$expected_output"
}

@test "test install biglybt package without display" {
    local DISPLAY="test"
    echo "echo \$DISPLAY" > "$tmp_biglybt_installer"
    run_set install_biglybt_from_installer_without_display "$tmp_biglybt_installer"
    assert_output ""
}