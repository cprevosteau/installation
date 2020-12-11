##!/usr/bin/env bash
set -euxo pipefail
include utils.sh

config_system() {
  original_dirs=(
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
