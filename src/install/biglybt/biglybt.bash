##!/usr/bin/env bash
include utils/move_to_system.bash
include utils/download.bash

install_biglybt() {
  local tmp_biglybt_installer="/tmp/BiglyBT_Installer.sh"
  download_biglybt_installer "$tmp_biglybt_installer"
  install_expect
  install_biglybt_from_installer_without_display "$tmp_biglybt_installer" "$APP_DIR/biglybt"
  rm "$tmp_biglybt_installer"
  move_from_home_to_system .biglybt
}

check_biglybt() {
  [[ $(readlink -f "$HOME/.biglybt") = "$SYSTEM_DIR/biglybt" ]]
  [[ -f "$APP_DIR/biglybt/biglybt" ]]
}

download_biglybt_installer() {
  local biglybt_installer="$1"
  download_file "https://files.biglybt.com/installer/BiglyBT_Installer.sh" "$biglybt_installer"
}

install_biglybt_from_installer_without_display() {
    local biglybt_installer="$1"
    local biglybt_directory="$2"
    local exp_file="$INSTALLATION_DIR/src/install/biglybt/config_biglybt.exp"
    expect -f "$exp_file" "$biglybt_installer" "$biglybt_directory"
}

install_expect() {
    sudo apt update
    sudo apt-get install -y expect
}