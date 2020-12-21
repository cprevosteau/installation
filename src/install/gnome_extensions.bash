##!/usr/bin/env bash

install_gnome_extensions() {
    sudo apt-get install -y gnome-tweaks
    install_sound_chooser
    restart_gnome
}

install_sound_chooser() {
    git clone https://github.com/kgshank/gse-sound-output-device-chooser.git
    mkdir -p "$HOME/.local/share/gnome-shell/extensions"
    cp --recursive gse-sound-output-device-chooser/sound-output-device-chooser@kgshank.net $HOME/.local/share/gnome-shell/extensions/sound-output-device-chooser@kgshank.net
}

restart_gnome() {
    busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
}