##!/usr/bin/env bash
include display/spinner.bash
includex install/*.bash

check_or_install() {
    local app="$1"
    (set -e; eval "check_$app"; set +e)
    if [ ! $? -eq 0 ]; then
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