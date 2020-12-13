##!/usr/bin/env bash
set -euo pipefail

import_src_and_env() {
  local -r src_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  . "${src_dir}/loader.bash"
  loader_addpath "${src_dir}"
  include set_and_check_env.bash

  pushd "${src_dir}/.."
  set_and_check_env
  popd
}

import_src_and_env
set +euo pipefail
