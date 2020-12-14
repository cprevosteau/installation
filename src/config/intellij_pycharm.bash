##!/usr/bin/env bash
include utils/move_to_system.bash

config_intellij_pycharm() {
  move_from_home_to_system ".config/JetBrains"
}