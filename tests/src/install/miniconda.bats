#!/usr/bin/env bats
load ../../import_helpers
load_src install/miniconda

setup() {
    # executed before each test
    echo "setup" >&3
    tmp_miniconda_file="${BATS_TMPDIR}/miniconda_status_code"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    [ ! -e "${tmp_miniconda_file}" ] || rm "${tmp_miniconda_file}"
}

@test "Test download miniconda (Is link active ?)" {
    download_file() {
      local url="${1}"
      local status_code_file="$2"
      download_status_code_to_file "${url}" "$status_code_file"
    }
    cmd_set download_miniconda "$tmp_miniconda_file"
    assert_file_exist "$tmp_miniconda_file"
    local status_code
    status_code=$(cat "$tmp_miniconda_file")
    assert_equal "$status_code" 200
}

@test "Test install miniconda package" {
    download_file() {
      local url="${1}"
      local output_file="${2}"
      # shellcheck disable=SC2016
      echo 'conda() { echo conda "${@}";}' >"${output_file}"
    }
    install_miniconda_package() {
      local miniconda_installer="${1}"
      source "${miniconda_installer}"
    }
    config_miniconda() {
      echo config_miniconda
    }
    run_set install_miniconda
    assert_success
    assert_file_not_exist "/tmp/miniconda_installer.sh"
    assert_equal "${lines[0]}" "config_miniconda"
    assert_equal "${lines[1]}"  "conda install -y -c conda-forge jupyterlab"
}

