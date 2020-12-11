readonly tests_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

test_src() {
  local -r src_file="${1}"
  local -r src_dir="${tests_dir}/../src"
  echo "$src_dir"
  (
    . "${src_dir}/import_src_and_env.sh"
    . "${src_dir}/${src_file}.sh"
  )
}
