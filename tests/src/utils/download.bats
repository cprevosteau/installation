#!/usr/bin/env bats
load ../../import_helpers
load_src utils/download

setup() {
    # executed before each test
    echo "setup" >&3
    tmp_file="google"
    tmp_file_path="$BATS_TMPDIR/$tmp_file"
    tmp_output_dir="/tmp/output_dir"
    mkdir "${tmp_output_dir}"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    [ ! -f "${tmp_file_path}" ] || rm "${tmp_file_path}"
    [ ! -d "${tmp_file_path}" ] || rm -r "${tmp_file_path}"
    rm -r "${tmp_output_dir}"
}

@test "test download_file" {
    run_set download_file https://www.google.com "${tmp_file_path}"
    assert_success
    assert_file_exist "${tmp_file_path}"
    [[ "$(awk 'NR==1' "${tmp_file_path}")" =~ "<!doctype html>" ]]
}

@test "test download_stream" {
    run_set download_stream https://www.google.com
    assert_success
    assert_output --partial '<!doctype html>'
}

@test "test download_extract_to_dir" {
    # Given
    download_stream() {
      mkdir "${tmp_file_path}"
      touch "${tmp_file_path}/test.test"
      local compressed_tmp_file="${tmp_file_path}.tar.gz"
      (cd "$tmp_file_path/.." && tar czf "${compressed_tmp_file}" "${tmp_file}")
      cat "${compressed_tmp_file}"
    }
    run_set download_extract_to_dir "www.google.com" "${tmp_output_dir}"
    assert_success
    assert_dir_exist "${tmp_output_dir}/${tmp_file}"
    assert_file_exist "${tmp_output_dir}/${tmp_file}/test.test"
}