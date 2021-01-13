##!/usr/bin/env bash
include utils/decorators.bash
include display/spin.bash
#    local spin="🕐"
#    local spin="🌚🌘🌗🌖🌒🌝"


open_fd() {
    local fd_number="$1"
    local fd_file
    fd_file=$(tty)
    eval "exec $fd_number>$fd_file"

}

spinner() {
    local cmd_arr=( "$@" )
    local msg="${cmd_arr[*]}"
    local fd_number=3
    spin "$msg" &
    local spin_pid=$!
    set_backtrace "$spin_pid" "$msg" "$fd_number"
    open_fd "$fd_number"
    eval_cmd "${cmd_arr[@]} $fd_number>&1 &>/dev/null"
    exit_code="$?"
    if [ "$exit_code" = 0 ]; then
        stop_spin_on_success $spin_pid "${cmd_arr[*]}"
    fi
    cleanup_backtrace
    close_fd "$fd_number"
    return $exit_code
}

backtrace() {
    local spin_pid="$1"
    local msg="$2"
    if kill -0 "$spin_pid" 2>/dev/null; then
        stop_spin_on_fail "$spin_pid" "$msg"
    fi
    local func="${FUNCNAME[1]}"
    local line="${BASH_LINENO[0]}"
    local src="${BASH_SOURCE[1]}"
    if [[ ! "$func" =~ (spinner|eval_cmd) ]]; then
        echo "  called from: $func(), $src, line $line"
    fi
    return 1
}

set_backtrace() {
    local spin_pid="$1"
    local msg="$2"
    local fd_number="$3"
    set -E
    trap "backtrace $spin_pid '$msg' >&$fd_number" ERR `seq 1 15`
}

cleanup_backtrace() {
    trap - ERR `seq 1 15`
    set +E
}

close_fd() {
    local fd_number="$1"
    eval "exec $fd_number>&-"
}