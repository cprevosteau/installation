##!/usr/bin/env bash

set_explorer(){
  add_folders_to_bookmark "${ENCRYPTED}" "/"
  set_show_hidden_files
  set_dark_theme
}

add_folders_to_bookmark() {
  local folders=( "$@" )
  local bookmark_file="${HOME}/.config/gtk-3.0/bookmarks"
  for folder in "${folders[@]}"
  do
    echo "file://${folder}" >>"${bookmark_file}"
  done
}

set_show_hidden_files() {
  gsettings set org.gtk.Settings.FileChooser show-hidden true
}

set_dark_theme() {
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
}
