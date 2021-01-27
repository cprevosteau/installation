##!/usr/bin/env bash
include utils/move_to_system.bash

install_system() {
  local -r original_dirs=(
    ".cache"
    "Downloads"
    ".ssh"
    ".gnupg"
  )
  for directory in "${original_dirs[@]}"
  do
    move_from_home_to_system "${directory}"
  done
}
