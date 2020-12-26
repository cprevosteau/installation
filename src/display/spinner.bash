##!/usr/bin/env bash
include utils/decorators.bash
include diplay/spin.bash
#    local spin="🕐"
#    local spin="🌚🌘🌗🌖🌒🌝"


open_fd3_if_not_set() {
    if [[ ! -e /proc/$$/fd/3 ]]; then
        exec 3>/dev/tty
    fi
}

spinner() {
    local cmd_arr=( "$@" )
    local msg="${cmd_arr[*]}"
    spin "$msg" &
    local spin_pid=$!
    set_backtrace "$spin_pid" "$msg"
    open_fd3_if_not_set
    eval_cmd "${cmd_arr[@]}" 3>&1 &>/dev/null
    exit_code="$?"
    if [ "$exit_code" = 0 ]; then
        stop_spin_on_success $spin_pid "${cmd_arr[*]}"
        cleanup_backtrace
    else
        return $exit_code
    fi
}

backtrace() {
    local spin_pid="$1"
    local msg="$2"
    exec 1>&3
    if kill -0 "$spin_pid" 2>/dev/null; then
        stop_spin_on_fail "$spin_pid" "$msg"
    fi
    local func="${FUNCNAME[1]}"
    local line="${BASH_LINENO[0]}"
    local src="${BASH_SOURCE[0]}"
    if [ $func = "spinner" ]; then
        cleanup_backtrace
    else
        echo "  called from: $func(), $src, line $line"
    fi
}

set_backtrace() {
    local spin_pid="$1"
    local msg="$2"
    set -E
    trap "backtrace $spin_pid '$msg'" ERR `seq 1 15`
}

cleanup_backtrace() {
    trap - ERR `seq 1 15`
    set +E
}

spinner 'sleep 3 && func1'