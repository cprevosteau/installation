##!/usr/bin/env bash
set -euxo pipefail

import_src_and_env() {
  local -r src_dirc=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  . "${src_dirc}/loader.bash"
  loader_addpath "${src_dirc}"
  include set_and_check_env.bash

  pushd "${src_dirc}/.."
  set_and_check_env
  popd
}

import_src_and_env