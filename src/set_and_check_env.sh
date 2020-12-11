##!/usr/bin/env bash
set -euxo pipefail

set_and_check_env(){
  dotenv
  local -r exported_vars=$(sed -e "s/=.*//" .env)
  echo "${exported_vars}" | check_filepath_or_directory_exists
  echo "${exported_vars}" | check_file_exist
}

dotenv () {
  set -a
  [ -f .env ] && . .env
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
      filepath="${FILES_DIR}/${!created_var}"
      if [ -f "${filepath}" ]; then
        echo "${created_var}" has been set with "${!created_var}" which exists
      else
        echo "Error: $created_var has been set with ${!created_var} which does not exists in $FILES_DIR"
        exit 1
      fi
    fi
  done
}