##!/usr/bin/env bash
set -euxo pipefail
include utils.sh

config_intellij_pycharm() {
  move_from_home_to_system ".config/JetBrains"
}

config_intellij_pycharm