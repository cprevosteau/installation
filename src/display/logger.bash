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
    local red_prefix end_of_color_suffix
    red_prefix=''
    end_of_color_suffix=''
    if [ "$level" == ERROR ]; then
        red_prefix=$(echo -e "\033[31m")
        end_of_color_suffix=$(echo -e "\033[0m")
    fi
    sed -e "s/^/$red_prefix$ts [$level] $package: /" -e "s/\$/$end_of_color_suffix/"
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

print_log() {
    local log_file="$1"
    local package="$2"
    local pattern_field_4="$package:"
    awk "{if (\$4==\"$pattern_field_4\") print \$0}" "$log_file"
    printf "The complete log is available here: %s\n" "$log_file"
}
