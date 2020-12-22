#!/bin/bash
set -e
echo "Decrypt partition"
sudo udisksctl unlock -b /dev/nvme0n1p8
sudo mount -t auto /dev/mapper/luks-b5e822b3-b0b1-43f2-a628-9bed9d29e44d "$ENCRYPTED_DIR"
sudo mount --bind "$SYSTEM_DIR/tmp" /tmp
sudo swapon "$ENCRYPTED_DIR/swapfile"
sudo mount --bind "$SYSTEM_DIR/config/autostart" "$AUTOSTART_DIR"
busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
sudo systemctl restart docker