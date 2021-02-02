##!/usr/bin/env bash

download_file() {
  local url="${1}"
  local output_file="${2}"
  wget -q --show-progress --progress=bar:force -O "${output_file}" "${url}"
}

download_stream() {
  local url="${1}"
  wget -q --show-progress --progress=bar:force -O- "${url}"
}

download_extract_to_dir() {
  local url="${1}"
  local output_directory="${2}"
  download_stream "${url}" | tar -xz --directory "${output_directory}"
}
