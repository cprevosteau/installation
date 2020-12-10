##!/usr/bin/env bash
echo Add encrypted folder and root folder as bookmark
echo "file://$ENCRYPTED_DIR" >> $HOME/.config/gtk-3.0/bookmarks
echo "file:///" >> $HOME/.config/gtk-3.0/bookmarks

echo Show hidden-files
gsettings set org.gtk.Settings.FileChooser show-hidden true

echo Set Dark theme
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

echo Run Decrypt script on startup
cp "$FILES_DIR/bash.desktop" "$HOME/.config/autostart/"
