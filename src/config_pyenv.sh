##!/usr/bin/env bash
set -euxo pipefail

config_pyenv() {
  {
    echo "export PYENV_ROOT=${PYENV_DIR}"
    echo 'export PATH="${PYENV_ROOT}/bin:${PATH}"'
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi'
  } >>"${BASHRC_FILEPATH}"
}

config_pyenv