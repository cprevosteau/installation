##!/usr/bin/env bash

ORIGINAL_DIRS=(
  ".cache"
  ".biglybt"
  "Downloads"
  ".ssh"
)

move_dir_and_set_symbolic_link() {
  ORIGINAL_DIR="$1"
  TARGET_DIR="$2"
  echo Move $ORIGINAL_DIR to $TARGET_DIR
  rsync -a -v --ignore-existing "$ORIGINAL_DIR/" "$TARGET_DIR"
  rm -rf "$ORIGINAL_DIR"
  ln -s "$TARGET_DIR" "$ORIGINAL_DIR"
}

for directory in "${ORIGINAL_DIRS[@]}"
do
  not_hidden_directory=`echo "${directory/./}"`
  original_dir="$HOME/$directory"
  target_dir="$SYSTEM_DIR/$not_hidden_directory"
  move_dir_and_set_symbolic_link $original_dir $target_dir
done

# TEST
# SYSTEM_DIR="/home/clement/encrypted/system" bash -ex /home/clement/encrypted/installation/new_ubuntu/system.sh
