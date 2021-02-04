##!/usr/bin/env bash
include display/spinner.bash
includex install/*.bash
include utils/checkers.bash

check_or_install() {
    local app="$1"
    if ! eval "check_$app"; then
        spinner_install "$LOG_FILE" "$app"
    fi
}

ask_for_reboot(){
    printf "A reboot is required in order to complete the installation of the drivers.\n"
    printf "Do you want to reboot now? (y/n)\n"
    read -n 1 -r yes_or_no
    echo
    if [[ $yes_or_no =~ ^[Yy]$ ]]
    then
        sudo reboot
    else
        exit 0
    fi
}
