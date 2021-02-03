##!/usr/bin/env bash
include utils/move_to_system.bash
include utils/download.bash
include utils/checkers.bash

install_intellij(){
    checker check_intellij_install
    if failure; then
        download_extract_to_dir "https://download.jetbrains.com/idea/ideaIC-2020.3.tar.gz" "${APP_DIR}"
    fi
    checker check_config_jetbrains
    if failure; then
        config_jetbrains
    fi
}

install_pycharm(){
    checker check_pycharm_install
    if failure; then
        download_extract_to_dir "https://download.jetbrains.com/python/pycharm-community-2020.3.tar.gz"  "${APP_DIR}"
    fi
    checker check_config_jetbrains
    if failure; then
        config_jetbrains
    fi
}

check_intellij_install() {
    ls $APP_DIR/idea*/bin/idea.sh &>/dev/null
}

check_pycharm_install() {
    ls $APP_DIR/pycharm*/bin/pycharm.sh &>/dev/null
}

config_jetbrains() {
    move_from_home_to_system ".config/JetBrains"
}

check_config_jetbrains() {
    [[ $(readlink -f "$HOME/.config/JetBrains") = "$SYSTEM_DIR/config/JetBrains" ]]
}
