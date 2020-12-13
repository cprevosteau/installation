##!/usr/bin/env bash
set -euo pipefail

install_bats() {
  git clone https://github.com/bats-core/bats-core.git "${APP_DIR}/bats-core"
  (
    cd "${APP_DIR}/bats-core"
    sudo ./install.sh /usr/local
  )
}