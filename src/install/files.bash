##!/usr/bin/env bash

set_files(){
    set_decryption_desktop
    set_decrypt_script
    set_bash_aliases
}

set_decryption_desktop() {
    set_file_via_tmp_mount_directory "$DECRYPTION_DESKTOP_FILE "
}

set_bash_aliases() {
    cp_with_env_subst "$FILES_DIR/$BASH_ALIASES_FILE" "$HOME"
}

set_decrypt_script() {
    cp_with_env_subst "$FILES_DIR/$DECRYPT_FILE" "$HOME"
}

set_file_via_tmp_mount_directory() {
    local filepath="$1"
    local target_dir="$2"
    local filename
    filename=$(basename "$filepath")
    local tmp_dir="/tmp/mounted"
    sudo mkdir -p "$tmp_dir"
    sudo mount --bind "$target_dir" "$tmp_dir"
    envsubst <"$filepath" > "$tmp_dir/$filename"
    sudo umount "$tmp_dir"
    sudo rm -rf "$tmp_dir"
}

cp_with_env_subst() {
    local src="$1"
    local tgt="$2"
    local filename
    filename=$(basename "$src")
    cp <(envsubst <"$src") "$tgt/$filename"
}