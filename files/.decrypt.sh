#!/bin/bash
set -e

decrypted_partition_path=/dev/mapper/luks-b5e822b3-b0b1-43f2-a628-9bed9d29e44d
windows_dir="/home/clement/windows"
swap_file="$ENCRYPTED_DIR/swapfile"

is_decrypted() {
  ls "$decrypted_partition_path" &>/dev/null && echo "The partition is already decrypted."
}
is_a_mount_point() {
  local mountpoint_path="$1"
  mountpoint -q "$mountpoint_path" && echo "$mountpoint_path is already mounted."
}
is_swap_file_in_use(){
  local swap_file="$1"
  swapon -s | grep -q "$swap_file " && echo "$swap_file is already an used swap file."
}

echo "Decrypt partition"
echo "Password:"
read -s password
echo "$password" | sudo -S echo "Password set"
is_decrypted || sudo udisksctl unlock -b /dev/nvme0n1p8
is_a_mount_point "$ENCRYPTED_DIR" || sudo mount -t auto "$decrypted_partition_path" "$ENCRYPTED_DIR"
is_a_mount_point "/tmp" || sudo mount --bind "$SYSTEM_DIR/tmp" /tmp
is_swap_file_in_use "$swap_file" || sudo swapon "$ENCRYPTED_DIR/swapfile"
is_a_mount_point "$AUTOSTART_DIR" || sudo mount --bind "$SYSTEM_DIR/config/autostart" "$AUTOSTART_DIR"
is_a_mount_point "$windows_dir" \
 || sudo mount -t cifs \\\\Desktop-j79l5i3\\i "$windows_dir" -o username=clement,password="$password" 2>/dev/null\
 || true
busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
sudo systemctl restart docker