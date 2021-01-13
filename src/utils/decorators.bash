##!/usr/bin/env bash

run_with_sudo() {
    local func_name="$1"
    local cmd_arr=( "$@" )
    local cmd_str
    cmd_str=$(make_cmd "${cmd_arr[@]}")
    sudo bash -c "$(declare -f "$func_name"); $cmd_str"
}

eval_cmd() {
    local cmd_arr=( "$@" )
    local cmd_str
    cmd_str=$(make_cmd "${cmd_arr[@]}" )
    eval "$cmd_str"
}

make_cmd () {
    local cmd_str="$1"
    for cmd in "${@:2}"; do
        cmd_str="$cmd_str '$cmd'"
    done;
    echo "$cmd_str"
}