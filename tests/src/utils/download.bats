#!/usr/bin/env bats
load ../../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    load_src utils/download
    tmp_file="/tmp/google"
    tmp_output_dir="/tmp/output_dir"
    mkdir "${tmp_output_dir}"
    set +u
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    [ ! -f ${tmp_file} ] || rm "${tmp_file}"
    [ ! -d ${tmp_file} ] || rm -r "${tmp_file}"
    rm -r "${tmp_output_dir}"
}

@test "test download_file" {
    run_set download_file https://www.google.com "${tmp_file}"
    assert_file_exist "${tmp_file}"
    [[ "$(awk 'NR==1' ${tmp_file})" =~ "<!doctype html>" ]]
}

@test "test download_stream" {
    run_set download_stream https://www.google.com >&3
    assert_file_exist "${tmp_file}"
    cat "${tmp_file}" >&3
    [[ "$(awk 'NR==1' ${tmp_file})" =~ "<!doctype html>" ]]
}

@test "test download_extract_to_dir" {
    # Given
    download_stream() {
      mkdir "${tmp_file}"
      touch "${tmp_file}/test.test"
      local compressed_tmp_file="${tmp_file}.tar.gz"
      echo "downloaded file" >"${tmp_file}"
      tar czvf "${compressed_tmp_file}" "${tmp_file}"
      cat "${compressed_tmp_file}"
    }

    run_set download_extract_to_dir  "${tmp_output_dir}"
    set +u
    assert_dir_exist "${tmp_output_dir}/google"
    assert_file_exist "${tmp_output_dir}/google/test.test"
}