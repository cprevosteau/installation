#!/usr/bin/env bash
readonly script_name=$(basename "${0}")
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly script_path="$script_dir/$script_name"

. $script_dir/../../../src/utils/import_src_and_env.bash
import_src_and_env
. $script_dir/../../../src/display/spinner.bash

#trap 'printf "   fail\n" && exit 1' ERR

cleanup_terminal_rgx='\e\[\?12l\e\[\?25h'
green_mark_rgx='\e\[32m✔\e\[0m'
red_cross_rgx='\e\[31m❌\e\[0m'
delete_end_line_rgx='\e\[K'
log_file=/tmp/test.log
package='test'
msg="Testing"

cleanup_test(){
    rm "$log_file" || true
}

######################################
printf "Test when function succeed \n"
# Given
tested_cmd="echo ok && sleep 2"
exp_line1="$green_mark_rgx  $msg $delete_end_line_rgx"
exp_line2="$cleanup_terminal_rgx"
expected_output_rgx="$exp_line1\n$exp_line2\n\$"

# When
actual_output=$(spinner "$log_file" "$package" "$msg" "$tested_cmd")

# Then
(echo "$actual_output" | grep -Pzo "$expected_output_rgx" &>/dev/null && \
  ls "$log_file" >/dev/null && \
  printf "   ok\n") || (printf "   fail: actual_output:\n %s\n" "$actual_output" && exit 1)
cleanup_test


######################################
printf "Test just one func which fails in backtrace \n"
# Given
func() {
    echo test
    sleep 2
    boom
}
boom() {
    echo boom >&2
    return 1
}
tested_cmd="func"
exp_line1="$red_cross_rgx  $msg $delete_end_line_rgx"
exp_line2="$cleanup_terminal_rgx  called from: func\(\), .*$script_name, line [0-9]+"
expected_output_rgx="$exp_line1\n$exp_line2\n"

# When
actual_output=$(spinner "$log_file" "$package" "$msg" "$tested_cmd")

# Then
(echo "$actual_output" | grep -Pzo "$expected_output_rgx" &>/dev/null && \
  ls "$log_file" >/dev/null && \
  printf "   ok\n") || (printf "   fail: actual_output: %s\n" "$actual_output" && exit 1)
cleanup_test


######################################
printf "Test backtrace when imbricated functions are called when one fails\n"
# Given
func2() {
    echo ok
    func
}

tested_cmd="func2"
exp_line1="$red_cross_rgx  $msg $delete_end_line_rgx"
exp_line2="$cleanup_terminal_rgx  called from: func\(\), .*$script_name, line [0-9]+"
exp_line3="  called from: func2\(\), .*$script_name, line [0-9]+"
expected_output_rgx="$exp_line1\n$exp_line2\n$exp_line3\n"

# When
actual_output=$(spinner "$log_file" "$package" "$msg" "$tested_cmd")

# Then
(echo "$actual_output" | grep -Pzo "$expected_output_rgx" &>/dev/null && \
  ls "$log_file" >/dev/null && \
  printf "   ok\n") || (printf "   fail\n" && exit 1)
cleanup_test
