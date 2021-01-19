##!/usr/bin/env bash
include utils/decorators.bash
include display/fd.bash
include display/spin.bash
include display/backtrace.bash
include logger/logger.bash
#    local spin="🕐"
#    local spin="🌚🌘🌗🌖🌒🌝"

spinner() {
    local cmd_arr=( "$@" )
    local msg="${cmd_arr[*]}"
    local fd_number=3
    spin "$msg" &
    local spin_pid=$!
    set_backtrace "$spin_pid" "$msg" "$fd_number"
    open_fd "$fd_number"
    eval_cmd "run_cmd_with_log $log_file $package ${cmd_arr[@]} $fd_number>&1"
    exit_code="$?"
    if [ "$exit_code" = 0 ]; then
        stop_spin_on_success $spin_pid "${cmd_arr[*]}"
    fi
    cleanup_backtrace
    close_fd "$fd_number"
    return $exit_code
}

