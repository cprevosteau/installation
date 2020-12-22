##!/usr/bin/env bash

set_decryption_desktop() {
  local -r tmp_config="/tmp/config"
  sudo mkdir -p "${tmp_config}"
  sudo mount --bind "${HOME}/.config" "${tmp_config}"
  envsubst <"${FILES_DIR}/${DECRYPTION_DESKTOP_FILE}" >>"${tmp_config}/autostart/${DECRYPTION_DESKTOP_FILE}"
  sudo umount "${tmp_config}"
}

