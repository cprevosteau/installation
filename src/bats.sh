##!/usr/bin/env bash
set -euxo pipefail
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


install_bats() {
  git clone https://github.com/bats-core/bats-core.git
  cd bats-core
  sudo ./install.sh /usr/local
} 

install_bats