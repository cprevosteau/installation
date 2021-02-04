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

@test "Test check install package when missing package" {
    check_command_in_new_env() {
        local package="$1"
        if [[ ! "first_package third_package" =~ "$1" ]]; then
            return 1
        fi
        return 0
    }

    run check_install_base_python_packages first_package missing_package third_package
    assert_failure
}

@test "Test check install package when all packages are there" {
    check_command_in_new_env() {
        return 0
    }

    check_install_base_python_packages first_package missing_package third_package
}
