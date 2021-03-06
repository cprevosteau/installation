##!/usr/bin/env bash

install_bats() {
  git clone https://github.com/bats-core/bats-core.git "${APP_DIR}/bats-core"
  cd "${APP_DIR}/bats-core" || exit
  sudo ./install.sh /usr/local
}

check_bats() {
  command -v bats
}
