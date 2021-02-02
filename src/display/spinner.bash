##!/usr/bin/env bash
include utils/decorators.bash
include display/fd.bash
include display/spin.bash
include display/backtrace.bash
include display/logger.bash
#    local spin="🕐"
#    local spin="🌚🌘🌗🌖🌒🌝"

spinner() {
    local log_file="$1"
    local app="$2"
    local msg="$3"
    local cmd_str="$4"
    local fd_number=3
    spin "$msg" "$log_file" &
    local spin_pid=$!
    set_backtrace "$spin_pid" "$msg" "$fd_number"
    open_fd "$fd_number"
    eval_cmd "run_cmd_with_log $log_file $app $cmd_str $fd_number>&1"
    exit_code="$?"
    if [ "$exit_code" = 0 ]; then
        stop_spin_on_success $spin_pid "$msg"
    else
        print_log "$log_file" "$app"
    fi
    cleanup_backtrace
    close_fd "$fd_number"
    return $exit_code
}

spinner_install() {
    local log_file="$1"
    local app="$2"
    local msg="Installation of $app"
    local cmd_str="install_$app"
    spinner "$log_file" "$app" "$msg" "$cmd_str"
}
