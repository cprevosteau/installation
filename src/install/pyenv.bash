##!/usr/bin/env bash
include utils/checkers.bash

install_pyenv() {
    if ! check_install_pyenv_package; then
        install_pyenv_package "$PYENV_DIR"
    fi
    config_pyenv "$PYENV_DIR"
}

check_pyenv() {
    check_install_pyenv_package && \
    check_config_pyenv
}

install_pyenv_package() {
    local pyenv_dir="$1"
    sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

    git clone https://github.com/pyenv/pyenv.git "$pyenv_dir"
}

check_install_pyenv_package() {
    check_command_in_new_env pyenv && \
    [[ -d "$PYENV_DIR" ]]
}

config_pyenv() {
    local pyenv_dir="$1"
    {
    echo "export PYENV_ROOT=$pyenv_dir"
    # shellcheck disable=SC2016
    echo 'export PATH="${PYENV_ROOT}/bin:${PATH}"'
    # shellcheck disable=SC2016
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi'
    } >>"$BASHRC_FILEPATH"
}

check_config_pyenv() {
    grep -q 'PYENV_ROOT' "$BASHRC_FILEPATH"
}
