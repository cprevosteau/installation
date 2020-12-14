##!/usr/bin/env bash

set_and_check_env(){
  local required_env_file="env/.env_required"
  local others_env_file="env/.env_others"
  export_env "${required_env_file}"
  export_env "${others_env_file}"
  local -r required_exported_vars=$(sed -e "s/=.*//" "${required_env_file}")
  echo "${required_exported_vars}" | check_filepath_or_directory_exists
  echo "${required_exported_vars}" | check_file_exist
}

export_env () {
  local -r env_file="${1}"
  set -a
  # shellcheck source=../../../../../../dev/null
  [ -f "${env_file}" ] && . "${env_file}"
  set +a
}


check_filepath_or_directory_exists() {
  while read -r created_var; do
    if [[ $created_var = *_DIR  || $created_var = *_FILEPATH ]]; then
      if [ -d "${!created_var}" ] || [ -f "${!created_var}" ]; then
        echo "${created_var}" has been set with "${!created_var}" which exists
      else
        echo Error: "${created_var}" has been set with "${!created_var}" which does not exists
        exit 1
      fi
    fi
  done
}

check_file_exist() {
    while read -r created_var; do
    if [[ $created_var = *_FILE ]]; then
      local filepath="${FILES_DIR}/${!created_var}"
      if [ -f "${filepath}" ]; then
        echo "${created_var}" has been set with "${!created_var}" which exists
      else
        echo "Error: $created_var has been set with ${!created_var} which does not exists in $FILES_DIR"
        exit 1
      fi
    fi
  done
}
