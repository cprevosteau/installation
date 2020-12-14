#!/usr/bin/env bats
load ../../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    load_src install/miniconda
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
      local output_file="${2}"
      download_status_code_to_file "${url}" "${output_file}"
    }
    run_set download_miniconda "${tmp_miniconda_file}"
    assert_file_exist "${tmp_miniconda_file}"
    assert_equal "$(cat "${tmp_miniconda_file}")" 200
}

@test "Test integration install miniconda" {
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
    assert_file_not_exist "/tmp/miniconda_installer.sh"
    assert_equal lines[1] "config_miniconda"
    assert_equal lines[2] "conda install -y -c conda-forge jupyterlab"
}

