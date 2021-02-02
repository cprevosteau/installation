##!/usr/bin/env bash
BOOKMARK_FILE="${HOME}/.config/gtk-3.0/bookmarks"

install_explorer(){
    add_folders_to_bookmark "${ENCRYPTED}" "/"
    set_show_hidden_files
    set_dark_theme
}

check_explorer(){
    check_bookmarks "${ENCRYPTED}" "/"
    check_dark_theme
    check_show_hidden_files
}

add_folders_to_bookmark() {
    local folders=( "$@" )
    for folder in "${folders[@]}"
    do
        if ! check_bookmarks "$folder"; then
            echo "file://${folder}" >>"$BOOKMARK_FILE"
        fi
    done
}

check_bookmarks() {
    local folders=( "$@" )
    for folder in "${folders[@]}"
    do
        grep -q "file://${folder}" "$BOOKMARK_FILE"
    done
}

set_show_hidden_files() {
    gsettings set org.gtk.Settings.FileChooser show-hidden true
}

check_show_hidden_files() {
    [[ $(gsettings get org.gtk.Settings.FileChooser show-hidden) == true ]]
}

set_dark_theme() {
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
}

check_dark_theme() {
    [[ $(gsettings get org.gnome.desktop.interface gtk-theme) == 'Adwaita-dark' ]]
}
