##!/usr/bin/env bash

run_set() {
  local -r cmd_arr=( "${@}" )
  set -uo pipefail
  run "${cmd_arr[@]}"
  set +uo pipefail
  assert_success
}

run_debug() {
  local -r cmd_arr=( "${@}" )
  set -euxo pipefail
  run "${cmd_arr[@]}"
  set +euxo pipefail
}

load_src() {
  local -r src_name="${1}"
  local -r helpers_dir="$(dirname "${BASH_SOURCE[0]}")"
  .  "${helpers_dir}/../../../src/utils/import_src_and_env.bash"
  import_src_and_env
  .  "${helpers_dir}/../../../src/${src_name}.bash"
}

download_status_code_to_file() {
  local url="${1}"
  local output_file="${2}"
  wget --spider --server-response "${url}" 2>&1 | nawk '(match($0,"HTTP/1\.1")) {print $2}' | tail --lines 1 >> "${output_file}"
}

download_status_code_to_stream() {
  local url="${1}"
  wget --spider --server-response "${url}" 2>&1 | nawk '(match($0,"HTTP/1\.1")) {print $2}' | tail --lines 1
}

save_function() {
    local orig_function_name="$1"
    local orig_function
    orig_function=$(declare -f "$orig_function_name")
    local new_function_name="$2"
    local function_with_new_name="$new_function_name${orig_function#$orig_function_name}"
    eval "$function_with_new_name"
}

mock_download_func() {
  local download_func_name="$1"
  if [ ! "$(command -v "$download_func_name")" ]; then
    echo "Download file must be loaded to be mocked"
  fi
  save_function "$download_func_name" "_$download_func_name"
  local new_func_definition="$download_func_name() { _$download_func_name \$@ 2>&3; }"
  eval "$new_func_definition"
}