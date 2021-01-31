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