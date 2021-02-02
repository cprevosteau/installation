#!/usr/bin/env bats
load ../../import_helpers
load_src display/spin

setup() {
    # executed before each test
    echo "setup" >&3
    log_file=/tmp/log
    spin_output=/tmp/spin_output
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    delete_if_file_exist "$log_file"
    delete_if_file_exist "$spin_output"
}

@test "spin with fixed log_file" {
    echo "test" > "$log_file"
    local remove_cursor_rgx='^\e\[\?25l'
    local color_rgx='\e\[337m'
    local spiner_rgx='(\\u28.{2}){2}'
    local end_color_rgx='\e\(B\e\[m'
    local delete_end_line_rgx='\e\[K'
    local msg="Message test"
    local spin_rgx="\r$color_rgx$spiner_rgx$end_color_rgx $msg: test $delete_end_line_rgx"
    local whole_rgx="$remove_cursor_rgx($spin_rgx)+$"

    spin "$msg" "$log_file" >"$spin_output" &
    local spin_pid=$!
    sleep 1
    echo before kill
    kill -9 "$spin_pid"
    echo "$spin_output"

    grep -P "$whole_rgx" "$spin_output"
}

@test "spin with changing log_file" {
    local line_log_1="line log 1"
    local line_log_2="line log 2"
    echo "$line_log_1" > "$log_file"
    local remove_cursor_rgx='^\e\[\?25l'
    local color_rgx='\e\[337m'
    local spiner_rgx='(\\u28.{2}){2}'
    local end_color_rgx='\e\(B\e\[m'
    local delete_end_line_rgx='\e\[K'
    local msg="Message test"
    local spin_rgx_1="\r$color_rgx$spiner_rgx$end_color_rgx $msg: $line_log_1 $delete_end_line_rgx"
    local spin_rgx_2="\r$color_rgx$spiner_rgx$end_color_rgx $msg: $line_log_2 $delete_end_line_rgx"
    local whole_rgx="$remove_cursor_rgx($spin_rgx_1)+($spin_rgx_2)+$"

    spin "$msg" "$log_file" >"$spin_output" &
    local spin_pid=$!
    sleep 1
    echo "$line_log_2" >> "$log_file"
    sleep 1
    echo before kill
    kill -9 "$spin_pid"
    echo "$spin_output"

    grep -P "$whole_rgx" "$spin_output"
}
