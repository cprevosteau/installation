##!/usr/bin/env bash

run_set() {
  local -r cmd_arr=( "${@}" )
  (run set -euo pipefail && "${cmd_arr[@]}")
}

run_debug() {
  local -r cmd_arr=( "${@}" )
  (run set -euxo pipefail && "${cmd_arr[@]}")
}

load_src() {
  local -r src_name="${1}"
  local -r helpers_dir="$(dirname "${BASH_SOURCE[0]}")"
  .  "${helpers_dir}/../../../src/utils/import_src_and_env.bash"
  .  "${helpers_dir}/../../../src/${src_name}.bash"
}

download_status_code_to_file() {
  local url="${1}"
  local output_file="${2}"
  wget --spider --server-response "${url}" 2>&1 | nawk '(match($0,"HTTP/1\.1")) {print $2}' >> "${output_file}"
}

download_status_code_to_stream() {
  local url="${1}"
  wget --spider --server-response "${url}" 2>&1 | nawk '(match($0,"HTTP/1\.1")) {print $2}'
}