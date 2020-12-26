##!/usr/bin/env bash
include utils/move_to_system.bash

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
