##!/usr/bin/env bash
set -euo pipefail

import_src_and_env() {
  local -r utils_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  . "${utils_dir}/loader.bash"
  local src_dir="${utils_dir}/.."
  loader_addpath "${src_dir}"
  include utils/set_and_check_env.bash

  pushd "${src_dir}/.."
  set_and_check_env
  popd
}

import_src_and_env
set +euo pipefail
