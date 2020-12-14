readonly tests_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

test_src() {
  local -r src_file="${1}"
  local -r src_dir="${tests_dir}/../src"
  echo "$src_dir"
  (
    . "${src_dir}/import_src_and_env.bash"
    . "${src_dir}/${src_file}.bash"
  )
}

test_docker_src() {
  local -r src_file="${1}"
  local option=""
  if [[ ${2} =~ (-t|--tap) ]]; then
    option="${2}"
  fi
  echo "$option"
  local -r src_dir="${tests_dir}/../src"
  (
    . "${src_dir}/utils/import_src_and_env.bash" >/dev/null && import_src_and_env
    docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" encrypted:latest bats "${tests_dir}/src/${src_file}.bats" "${option}"
  )
}

test_docker_real_install() {
  local -r src_file="${1}"
  local -r src_dir="${tests_dir}/../src"
  (
    . "${src_dir}/utils/import_src_and_env.bash" >/dev/null && import_src_and_env
    docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" encrypted:latest bats --tap  "${tests_dir}/real_install/${src_file}.bats"
  )
}
