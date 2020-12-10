##!/usr/bin/env bash
echo Add encrypted folder and root folder as bookmark
echo "file://$ENCRYPTED_DIR" >> $HOME/.config/gtk-3.0/bookmarks
echo "file:///" >> $HOME/.config/gtk-3.0/bookmarks

echo Show hidden-files
dconf write /org/gtk/settings/file-chooser/show-hidden true

echo Run Decrypt script on startup
cp "$FILES_DIR/bash.desktop" "$HOME/.config/autostart/"
