##!/usr/bin/env bash
include config/intellij_pycharm.bash
include utils/download.bash

install_intellij_pycharm(){
  download_extract_to_dir "https://download.jetbrains.com/idea/ideaIC-2020.3.tar.gz" "${APP_DIR}"
  download_extract_to_dir "https://download.jetbrains.com/python/pycharm-community-2020.3.tar.gz"  "${APP_DIR}"
  config_intellij_pycharm
}

