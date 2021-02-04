##!/usr/bin/env bash

check_command_in_new_env() {
    local cmd="$1"
    env -i HOME=$HOME bash -ic "command -v $cmd" &>/dev/null
}

checker() {
    local cmd_arr=("$@")
    local old_state
    old_state=$(set +o)
    check=true
    set +e
    set -E
    catch(){
        echo "catch" >&3
        check=false
        return 1
    }
    trap catch ERR
    (
        eval "${cmd_arr[@]}"
        echo  eval  "${cmd_arr[@]}" $? >&3
        echo not fail >&3
    )
    echo end of sub $? >&3
    eval "$old_state"
}

get_e_option() {
    if set +o | grep -q 'set +o errtrace'; then
        echo +
    else
        echo -
    fi
}

success() {
    [[ $? -eq 0 ]]
}

failure() {
    [[ ! $? -eq 0 ]]
}
