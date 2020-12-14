##!/usr/bin/env bash

download_file() {
  local url="${1}"
  local output_file="${2}"
  wget -q --show-progress --progress=bar:force -O "${output_file}" "${url}" 2>&1
}

download_stream() {
  local url="${1}"
  wget -q --show-progress --progress=bar:force -O- "${url}"
}