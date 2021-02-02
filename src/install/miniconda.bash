##!/usr/bin/env bash
include utils/download.bash

install_miniconda() {
    if ! check_miniconda_package; then
        local -r miniconda_tmp_file="/tmp/miniconda_installer.sh"
        download_miniconda "$miniconda_tmp_file"
        install_miniconda_package "$miniconda_tmp_file"
        rm "$miniconda_tmp_file"
    fi
    if ! check_miniconda_config; then
        config_miniconda
    fi
    if ! check_install_base_python_packages; then
        install_base_python_packages
    fi
}

check_miniconda() {
    check_miniconda_package
    check_config_miniconda
    check_install_base_python_packages
}

install_miniconda_package() {
    local -r miniconda_installer_file="$1"
    #https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html#install-macos-silent
    local miniconda_installer_options=(-b -f -p "$MINICONDA_DIR")
    sh "$miniconda_installer_file" "${miniconda_installer_options[@]}"
}

check_miniconda_package() {
    [[ -d "$MINICONDA_DIR" ]]
}

install_base_python_packages(){
    conda install -y -c conda-forge jupyterlab jupytext
}

check_install_base_python_packages(){
    command -v jupyter-lab
    command -v jupytext
}

download_miniconda() {
    local -r miniconda_installer_file="$1"
    download_file https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh "$miniconda_installer_file"
}

config_miniconda() {
    #https://docs.anaconda.com/anaconda/install/silent-mode/
    eval "$("${MINICONDA_DIR}/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
    conda init
}

check_config_miniconda() {
    env -i bash -ic "command -v conda"
}