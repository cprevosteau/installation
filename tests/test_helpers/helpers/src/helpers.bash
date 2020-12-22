##!/usr/bin/env bash

cleanup() {
    eval "$old_state"
    set -e
    cat stderr.log >&3 2>/dev/null || true
    [ -z "$output" ] || echo "$output" >&3 2>/dev/null
    rm stderr.log 2>/dev/null || true
}

cleanup_exit() {
    cleanup
    exit 1
}

cmd_set(){
    local cmd_arr=( "${@}" )
    old_state=$(set +o)
    set -uo pipefail
    cmd_str=$(make_cmd "${cmd_arr[@]}")
    eval "$cmd_str" 2> >(tee stderr.log >&2) || cleanup_exit
    cleanup
}

make_cmd () {
    local cmd_str="$1"
    for cmd in "${@:2}"; do
        cmd_str="$cmd_str '$cmd'"
    done;
    echo "$cmd_str"
}

run_set() {
  local cmd_arr=( "${@}" )
  old_state=$(set +o)
  set -uo pipefail
  run "${cmd_arr[@]}" || cleanup_exit
  cleanup
}

load_src() {
  local -r src_name="${1}"
  local -r helpers_src_dir="$(dirname "${BASH_SOURCE[0]}")"
  .  "${helpers_src_dir}/../../../../src/utils/import_src_and_env.bash"
  import_src_and_env
  .  "${SRC_DIR}/${src_name}.bash"
}

skip_if_not_in_docker(){
    local docker_hostname_regexp="[[:xdigit:]]{12}"
    [[ "$HOSTNAME" =~ $docker_hostname_regexp  ]] || skip
}

skip_if_in_docker(){
    local docker_hostname_regexp="[[:xdigit:]]{12}"
    [[ ! "$HOSTNAME" =~ $docker_hostname_regexp  ]] || skip
}

add_cmd_to_func_def() {
    local func_def="$1"
    local first_cmd_to_add=("${@:2}")
    local start_pattern="{"
    local new_line="$start_pattern"
    for cmd_to_add in "${first_cmd_to_add[@]}"; do
        new_line="$new_line $cmd_to_add;"
    done;
    # shellcheck disable=SC2001
    echo "$func_def" | sed -e "s/$start_pattern/$new_line/"
}

save_function() {
	local orig_function_name="$1"
	local orig_function
	orig_function=$(declare -f "$orig_function_name")
	local new_function_name="$2"
	local new_func_def="$new_function_name${orig_function#$orig_function_name}"
	new_func_def=$(add_cmd_to_func_def "$new_func_def" "${@:3}")
	eval "$new_func_def"
}

assert_valid_json() {
    local json_file="$1"
    jq -e . "$json_file" >/dev/null 2>&1
}

assert_command_exist() {
    local cmd="$1"
    assert [ "$( command -v "$cmd")" ]
}

create_file() {
    local filepath="$1"
    local dir
    dir=$(dirname "$filepath")
    mkdir -p "$dir"
    touch "$filepath"
}

delete_if_file_exist() {
    local filepath="$1"
    [ ! -f "$filepath" ] || rm "$filepath"
}

delete_if_directory_exist() {
    local directory="$1"
    [ ! -d "$directory" ] || rm -rf "$directory"
}