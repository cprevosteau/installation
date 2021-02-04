##!/usr/bin/env bash
include utils/download.bash

install_poetry(){
    download_poetry | install_poetry_package "$POETRY_DIR"
}
check_poetry(){
    [[ -d "$POETRY_DIR" ]] && \
    env -i HOME="$HOME" bash -lc "command -v poetry"
}

download_poetry() {
    local installer_url="https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py"
    download_stream "$installer_url"
}

install_poetry_package(){
    local poetry_dir="$1"
    POETRY_HOME="$poetry_dir" python -
}
