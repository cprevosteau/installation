##!/usr/bin/env bash

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
