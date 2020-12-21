#!/usr/bin/env bats
load ../../../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    output_file="install.sh"
    output_path="$BATS_TMPDIR/$output_file"
    url="https://www.google.com"
    DATA_DIR="$BATS_TMPDIR/data"
    mkdir "$DATA_DIR" || rm "$DATA_DIR/"* || true
    url_file="installer.sh"
    url="https://sitetest.com/$url_file"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    rm -r "$DATA_DIR"
    rm $output_path || true
    rm "$BATS_TMPDIR/$url_file" || true
}

@test "mock_download_func_to_use_stored_data with download_file without existing file" {
    # Given
    download_file(){
        echo "download_file has been called." 2>&1
        echo "$1 ----> $2" >"$2"
    }
    local data_path="$DATA_DIR/$output_file"
    assert_file_not_exist "$data_path"
    assert_file_not_exist "$output_path"

    # When
    cmd_set mock_download_func_to_use_stored_data download_file
    run_set download_file "$url" "$output_path"
    assert_success

    assert_file_exist "$data_path"
    assert_equal "$(cat "$data_path")" "$url ----> $output_path"
    assert_file_exist "$output_path"
    assert_equal "$(cat "$output_path")" "$url ----> $output_path"
    assert_output "download_file has been called."
}

@test "mock_download_func_to_use_stored_data with download_file with existing file" {
    # Given
    download_file(){
        echo "download_file has been called." 2>&1
        echo "$1 ----> $2" >"$2"
    }
    local data_path="$DATA_DIR/$output_file"
    echo "stored_data" >"$data_path"
    assert_file_exist "$data_path"
    assert_file_not_exist "$output_path"

    # When
    cmd_set mock_download_func_to_use_stored_data download_file
    run_set download_file "$url" "$output_path"
    assert_success

    assert_file_exist "$data_path"
    assert_equal "$(cat "$data_path")" "stored_data"
    assert_file_exist "$output_path"
    assert_equal "$(cat "$output_path")" "stored_data"
    assert_output ""
}

@test "mock_download_func_to_use_stored_data with download_stream without existing file" {
    # Given
    download_stream(){
        echo "download_stream has been called." >&2
        echo "$1 ---->"
    }
    local data_path="$DATA_DIR/$url_file"
    assert_file_not_exist "$data_path"

    # When
    cmd_set mock_download_func_to_use_stored_data download_stream
    cmd_set download_stream "$url" >"$BATS_TMPDIR/stdin" 2>"$BATS_TMPDIR/stder"

    # Then
    assert_file_exist "$data_path"
    assert_equal "$(cat "$data_path")" "$url ---->"
    assert_file_exist "$BATS_TMPDIR/stdin"
    assert_equal "$(cat "$BATS_TMPDIR/stdin")" "$url ---->"
    assert_file_exist "$BATS_TMPDIR/stder"
    assert_equal "$(cat "$BATS_TMPDIR/stder")" "download_stream has been called."
}

@test "mock_download_func_to_use_stored_data with download_stream with existing file" {
    # Given
    download_stream(){
        echo "download_stream has been called." 2>&1
        echo "$1 ---->"
    }
    local data_path="$DATA_DIR/$url_file"
    echo "stored_data" >"$data_path"

    # When
    cmd_set mock_download_func_to_use_stored_data download_stream
    cmd_set download_stream "$url" >"$BATS_TMPDIR/stdin" 2>"$BATS_TMPDIR/stder"

    # Then
    assert_file_exist "$data_path"
    assert_equal "$(cat "$data_path")" "stored_data"
    assert_file_exist "$BATS_TMPDIR/stdin"
    assert_equal "$(cat "$BATS_TMPDIR/stdin")" "stored_data"
    assert_file_exist "$BATS_TMPDIR/stder"
    assert_equal "$(cat "$BATS_TMPDIR/stder")" ""
}