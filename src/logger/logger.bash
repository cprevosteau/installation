##!/usr/bin/env bash
include utils/decorators.bash

timestamp() {
    date '+%F %X'
}

prefix_level() {
    local level="$1"
    local package="$2"
    trap "" INT TERM
    local ts
    ts="$(timestamp)"
    sed "s/^/$ts [$level] $package: /"
}

run_cmd_with_log() {
    local log_file="$1"
    local package="$2"
    local cmd_arr=("${@:3}")
    (
        eval_cmd "${cmd_arr[@]}" | prefix_level INFO "$package" >> "$log_file"
        return "${PIPESTATUS[0]}"
    ) 2>&1 | prefix_level ERROR "$package" >> "$log_file"
    return "${PIPESTATUS[0]}"
}
