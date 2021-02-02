##!/usr/bin/env bash
include utils/move_to_system.bash
ORIGINAL_DIRS=(
        ".cache"
        "Downloads"
        ".ssh"
        ".gnupg"
      )


install_system() {
    for directory in "${ORIGINAL_DIRS[@]}"
    do
        move_from_home_to_system "${directory}"
    done
}

check_system() {
    for directory in "${ORIGINAL_DIRS[@]}"
    do
        [[ -h "$HOME/$directory" ]]
    done
}
