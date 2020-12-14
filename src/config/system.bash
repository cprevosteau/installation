##!/usr/bin/env bash
set -euxo pipefail
include utils.bash

config_system() {
  local -r original_dirs=(
    ".cache"
    "Downloads"
    ".ssh"
  )
  for directory in "${original_dirs[@]}"
  do
    move_from_home_to_system "${directory}"
  done
}

config_system
