##!/usr/bin/env bash
include utils/download.bash

install_slack() {
  tmp_file="/tmp/slack.deb"
  download_file https://downloads.slack-edge.com/linux_releases/slack-desktop-4.11.3-amd64.deb "$tmp_file"
  sudo apt-get update
  sudo apt install -y "${tmp_file}"
}