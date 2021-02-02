##!/usr/bin/env bash

install_files(){
    set_decryption_desktop
    set_decrypt_script
    set_bash_aliases
}

check_files(){
    check_file_via_tmp_mount_directory "$DECRYPTION_DESKTOP_FILE" "$AUTOSTART_DIR"
    [[ -f "$HOME/$BASH_ALIASES_FILE" ]]
    [[ -f "$HOME/$DECRYPT_FILE" ]]
}

set_decryption_desktop() {
    set_file_via_tmp_mount_directory "$FILES_DIR/$DECRYPTION_DESKTOP_FILE" "$AUTOSTART_DIR" \
     '$HOME $DECRYPT_FILE'
}

set_bash_aliases() {
    cp_with_env_subst "$FILES_DIR/$BASH_ALIASES_FILE" "$HOME"
}

set_decrypt_script() {
    cp_with_env_subst "$FILES_DIR/$DECRYPT_FILE" "$HOME" \
        '$SYSTEM_DIR $ENCRYPTED_DIR $SYSTEM_DIR $AUTOSTART_DIR'
}

set_file_via_tmp_mount_directory() {
    local filepath="$1"
    local target_dir="$2"
    local env_vars_to_be_replaced="$3"
    local filename already_mounted_dir to_mount_dir
    filename=$(basename "$filepath")
    already_mounted_dir=$(find_first_mountpoint "$target_dir")
    to_mount_dir=$(dirname "$already_mounted_dir")
    local target_subdir="${target_dir##$to_mount_dir/}"
    local tmp_dir="/tmp/mounted"
    local target_mounted_tmp_dir="$tmp_dir/$target_subdir"
    sudo mkdir -p "$tmp_dir"
    sudo mount --bind "$to_mount_dir" "$tmp_dir"
    cp_with_env_subst "$filepath" "$target_mounted_tmp_dir" "$env_vars_to_be_replaced"
    sleep 1
    sudo umount "$tmp_dir"
    sudo rm -rf "$tmp_dir"
}

check_file_via_tmp_mount_directory(){
    local filename="$1"
    local target_dir="$2"
    local already_mounted_dir to_mount_dir
    already_mounted_dir=$(find_first_mountpoint "$target_dir")
    to_mount_dir=$(dirname "$already_mounted_dir")
    local target_subdir="${target_dir##$to_mount_dir/}"
    local tmp_dir="/tmp/mounted"
    local target_mounted_tmp_dir="$tmp_dir/$target_subdir"
    sudo mkdir -p "$tmp_dir"
    sudo mount --bind "$to_mount_dir" "$tmp_dir"
    ls "$target_mounted_tmp_dir/$filename"
    sleep 1
    sudo umount "$tmp_dir"
    sudo rm -rf "$tmp_dir"
}

find_first_mountpoint() {
  filepath="$1"
  path_to_test="$filepath"
  while ! mountpoint -q "$path_to_test"
  do
    path_to_test=$(dirname "$path_to_test")
  done
  if [ "$path_to_test" != '/' ]; then
    echo "$path_to_test"
  else
    echo "$filepath"
  fi
}

cp_with_env_subst() {
    local src="$1"
    local tgt="$2"
    local env_vars_to_be_replaced="$3"
    local filename
    filename=$(basename "$src")
    envsubst "$env_vars_to_be_replaced" <"$src" >"$tgt/$filename"
}
