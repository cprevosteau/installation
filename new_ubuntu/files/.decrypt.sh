#!/bin/bash
echo "Decrypt partition"
sudo udisksctl unlock -b /dev/nvme0n1p8
sudo mount -t auto /dev/mapper/luks-b5e822b3-b0b1-43f2-a628-9bed9d29e44d /home/clement/encrypted
sudo swapon /home/clement/encrypted/swapfile
sleep 1
busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
