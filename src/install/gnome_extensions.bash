##!/usr/bin/env bash

install_gnome_extensions() {
    sudo apt-get update
    sudo apt-get install -y gnome-tweaks
    install_sound_chooser
    restart_gnome
}

check_gnome_extensions() {
    command -v gnome-extensions && \
    check_sound_chooser
}

install_sound_chooser() {
    git clone https://github.com/kgshank/gse-sound-output-device-chooser.git
    mkdir -p "$HOME/.local/share/gnome-shell/extensions"
    cp --recursive gse-sound-output-device-chooser/sound-output-device-chooser@kgshank.net $HOME/.local/share/gnome-shell/extensions/sound-output-device-chooser@kgshank.net
}

check_sound_chooser() {
    gnome-extensions list | grep -q 'sound-output-device-chooser@kgshank.net'
}

restart_gnome() {
    busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
}
