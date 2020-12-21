##!/usr/bin/env bash
include install/docker.bash


set_normal_data_root() {
    change_data_root "/var/lib/docker"
}

set_encrypted_data_root() {
    change_data_root "$SYSTEM_DIR/docker"
}

change_data_root() {
    local new_path="$1"
    local docker_daemon_file="/etc/docker/daemon.json"
    local old_path
    old_path="$(jq '.["data-root"]' $docker_daemon_file | tr -d '"')"
    if [ ! "$old_path" = "$new_path" ]; then
        # shellcheck disable=SC2086
        sudo rsync -aP "$old_path/" "$new_path"
        set_data_root_directory "$new_path"
    fi
}
