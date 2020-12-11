##!/usr/bin/env bash
set -euxo pipefail
readonly installation_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${installation_dir}/src/import_src_and_env.sh"

install_pyenv() {
  echo Install prerequisites
  sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

  git clone https://github.com/pyenv/pyenv.git "${PYENV_DIR}"
  include config_pyenv.sh
}

install_pyenv