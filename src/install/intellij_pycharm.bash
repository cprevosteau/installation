##!/usr/bin/env bash
include utils/move_to_system.bash
include utils/download.bash

install_intellij_pycharm(){
  download_extract_to_dir "https://download.jetbrains.com/idea/ideaIC-2020.3.tar.gz" "${APP_DIR}"
  download_extract_to_dir "https://download.jetbrains.com/python/pycharm-community-2020.3.tar.gz"  "${APP_DIR}"
  config_intellij_pycharm
}

check_intellij_pycharm() {
  [[ $(readlink -f "$HOME/.config/JetBrains") = "$SYSTEM_DIR/config/JetBrains" ]]
  ls $APP_DIR/pycharm*/bin/pycharm.sh
  ls $APP_DIR/idea*/bin/idea.sh
}

config_intellij_pycharm() {
  move_from_home_to_system ".config/JetBrains"
}
