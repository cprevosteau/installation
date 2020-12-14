##!/usr/bin/env bash
set -euxo pipefail

install_biglybt() {
  bigly_file="BiglyBT_Installer.sh"
  bigly_path="/tmp/${bigly_file}"
  wget -O "${bigly_path}" "https://files.biglybt.com/installer/${bigly_file}"
  sh "${bigly_path}"
  rm "${bigly_path}"
  include utils.bash
  move_from_home_to_system .biglybt
}

install_biglybt