##!/usr/bin/env bash
include utils/move_to_system.bash
include utils/download.bash

install_biglybt() {
  local tmp_biglybt_installer="/tmp/BiglyBT_Installer.sh"
  download_biglybt_installer "$tmp_biglybt_installer"
  install_biglybt_from_installer_without_display "$tmp_biglybt_installer"
  rm "$tmp_biglybt_installer"
  move_from_home_to_system .biglybt
}

download_biglybt_installer() {
  local biglybt_installer="$1"
  download_file "https://files.biglybt.com/installer/BiglyBT_Installer.sh" "$biglybt_installer"
}

install_biglybt_from_installer_without_display() {
    local biglybt_installer="$1"
    local read_biglybt_directory="$APP_DIR/biglybt"
    local read_create_desktop_icon="y"
    local read_classic_ui="2"
    local read_clear_old_configuration="n"
    local read_install_tor_helper_plugin="7"
    DISPLAY="" sh "$biglybt_installer" <<EOF
$read_biglybt_directory
$read_create_desktop_icon
$read_classic_ui
$read_clear_old_configuration
$read_install_tor_helper_plugin
EOF
}