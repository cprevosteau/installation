##!/usr/bin/env bash
set -euxo pipefail

move_dir_and_set_symbolic_link() {
  local -r original_dir="${1}"
  local -r target_dir="${2}"
  local -r cmd_prefix="${3}"
  echo Move "${original_dir}" to "${target_dir}"
  mkdir -p "${target_dir}"
  if [ -d "${original_dir}" ] || [ -f "${original_dir}" ]; then
    eval "${cmd_prefix} rsync -a -v --ignore-existing ${original_dir}/ ${target_dir}"
    eval "${cmd_prefix} rm -rf ${original_dir}"
  fi
  ln -s "${target_dir}" "${original_dir}"
}

move_from_home_to_system() {
  local -r directory="$1"
  move_to_system "${HOME}" "${directory}"
}

move_to_system() {
  local -r prefix="${1}"
  local -r directory="${2}"
  local -r cmd_prefix=$( set +u;  [ -n "${3}" ] && [ "${3}" = "--with-sudo" ] && echo "sudo" || echo )
  local -r not_hidden_directory="${directory/./}"
  local -r original_dir="${prefix}/${directory}"
  local -r target_dir="${SYSTEM_DIR}/${not_hidden_directory}"
  move_dir_and_set_symbolic_link "${original_dir}" "${target_dir}" "${cmd_prefix}"
}

