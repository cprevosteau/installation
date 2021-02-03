##!/usr/bin/env bash

check_command_in_new_env() {
    local cmd="$1"
    env -i HOME=$HOME bash -ic "command -v $cmd" &>/dev/null
}

checker() {
    local cmd_arr=("$@")
    (
        set -e
        eval "${cmd_arr[@]}"
        set +e
    )
}

success() {
    [[ $? -eq 0 ]]
}

failure() {
    [[ ! $? -eq 0 ]]
}
