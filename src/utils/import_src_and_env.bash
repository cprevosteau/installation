##!/usr/bin/env bash

import_src_and_env() {
  local -r utils_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  . "${utils_dir}/loader-extended.bash"
  local src_dir="${utils_dir}/.."
  loader_addpath "${src_dir}"
  include utils/set_and_check_env.bash

  pushd "${src_dir}/.." >/dev/null || exit
  set_and_check_env
  popd >/dev/null || exit
}
