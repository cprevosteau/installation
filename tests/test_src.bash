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
  local -r src_dir="${tests_dir}/../src"
  (
    . "${src_dir}/import_src_and_env.bash" >/dev/null
    docker run -itv "${INSTALLATION_DIR}:${INSTALLATION_DIR}:ro" encrypted:latest bats "${tests_dir}/src/${src_file}.bats"
  )
}
