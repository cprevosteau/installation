#!/usr/bin/env bash
readonly script_name=$(basename "${0}")
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly script_path="$script_dir/$script_name"

. ../../../src/utils/import_src_and_env.bash
import_src_and_env
. ../../../src/display/spinner.bash

cleanup_terminal_rgx='\e\[\?12l\e\[\?25h'
green_mark_rgx='\e\[32m✔\e\[0m'
red_cross_rgx='\e\[31m❌\e\[0m'

printf "Test when function succeed \n"
# Given
tested_cmd="sleep 2 && echo ok"
exp_line1="$green_mark_rgx  $tested_cmd"
exp_line2="$cleanup_terminal_rgx"
expected_output_rgx="$exp_line1\n$exp_line2\n\$"

# When
actual_output=$(spinner "$tested_cmd")

# Then
(echo "$actual_output" | grep -Pzo "$expected_output_rgx" &>/dev/null && \
 printf "   ok\n") || (printf "   fail\n" && exit 1)


printf "Test just one func which fails in backtrace \n"
# Given
func() {
    boom
}
boom() {
    echo boom
    return 1
}
tested_cmd="sleep 2 && func"
exp_line1="$red_cross_rgx  $tested_cmd"
exp_line2="$cleanup_terminal_rgx  called from: func\(\), $script_path, line [0-9]+"
expected_output_rgx="$exp_line1\n$exp_line2\n\$"

# When
actual_output=$(spinner "$tested_cmd")

# Then
(echo "$actual_output" | grep -Pzo "$expected_output_rgx" &>/dev/null && \
 printf "   ok\n") || (printf "   fail\n" && exit 1)



printf "Test backtrace when imbricated functions are called when one fails\n"
# Given
func2() {
    echo ok
    func
}

tested_cmd="sleep 2 && func2"
exp_line1="$red_cross_rgx  $tested_cmd"
exp_line2="$cleanup_terminal_rgx  called from: func\(\), $script_path, line [0-9]+"
exp_line3="  called from: func2\(\), $script_path, line [0-9]+"
expected_output_rgx="$exp_line1\n$exp_line2\n$exp_line3\n\$"

# When
actual_output=$(spinner "$tested_cmd")

# Then
(echo "$actual_output" | grep -Pzo "$expected_output_rgx" &>/dev/null && \
 printf "   ok\n") || (printf "   fail\n" && exit 1)