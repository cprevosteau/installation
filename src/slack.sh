##!/usr/bin/env bash
set -euxo pipefail
readonly script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

slack() {
  tmp_file="/tmp/slack.deb"
  wget -c -O "${tmp_file}" https://downloads.slack-edge.com/linux_releases/slack-desktop-4.11.3-amd64.deb
  sudo apt install "${tmp_file}"
}

slack