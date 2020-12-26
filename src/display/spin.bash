#!/bin/bash
#    local spin="🌚🌘🌗🌖🌒🌝"

get_braille(){
    local code="$1"
    local res=0x28ff
    for (( i=0; i<${#code}; i++ )); do
        local pwr=${code:$i:1}
        res=$(( res - (2 ** (pwr - 1))))
    done
    local chr=$(printf "%s%x" "\\u" "$res")
    echo -e "$chr"
}

get_empty_dot_position(){
    local i="$1"
    local round_dot_array=( 11 14 21 24 25 26 28 27 18 17 13 12 )
    local round_period="${#round_dot_array[@]}"
    local index=$(( (i - 1) % round_period))
    echo "${round_dot_array[$index]}"
}

get_centre_pattern() {
    local i="$1"
    center_pattern=( 56 23 )
    echo "${center_pattern[*]}"
}

get_frame(){
    local i="$1"
    local pattern empty_dot_position empty_dot_part empty_dot_octal
    pattern=( $(get_centre_pattern "$i") )
    empty_dot_position=$(get_empty_dot_position $i)
    empty_dot_part=${empty_dot_position:0:1}
    empty_dot_octal=${empty_dot_position:1:1}
    pattern[$((empty_dot_part - 1))]="${pattern[$((empty_dot_part - 1))]}$empty_dot_octal"
    echo "$(get_braille ${pattern[0]})$(get_braille ${pattern[1]})"
}

spin()
{
    local cmd_arr=( "$@" )
    local color="37"
    tput civis
    local i=1
    while :
    do
        local frame="$( get_frame "$i")"
        cursor_back
        printf "$(set_color $color)%s$(reset_color) %s $(delete_end_of_line)" "$frame" "${cmd_arr[*]}"
        sleep .1
        i=$((i + 1))
    done
}

cursor_back() {
  echo -en "\r"
}

set_color() {
    local color="$1"
    tput setaf "$color"
}

reset_color() {
    tput sgr0
}

delete_end_of_line() {
    tput el
}

stop_spin_on_success() {
    local spin_pid="$1"
    local msg="$2"
    local green_check_mark="\033[32m✔\033[0m"
    kill -9 "$spin_pid"
    cursor_back
    printf "%b  %s" "$green_check_mark" "$msg"
    cleanup_terminal
}


cleanup_terminal() {
    printf "\n"
    tput cnorm
}

stop_spin_on_fail() {
    local spin_pid="$1"
    local msg="$2"
    local red_cross="\033[31m❌\033[0m"
    kill -9 "$spin_pid"
    cursor_back
    printf "%b  %s" "$red_cross" "$msg"
    cleanup_terminal
    exit 1
}