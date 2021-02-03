##!/usr/bin/env bash
include utils/download.bash
include utils/checkers.bash

BASE_PACKAGES=( jupyterlab jupytext pre-commit )

install_miniconda() {
    checker check_miniconda_package
    if failure; then
        local -r miniconda_tmp_file="/tmp/miniconda_installer.sh"
        download_miniconda "$miniconda_tmp_file"
        install_miniconda_package "$miniconda_tmp_file"
        rm "$miniconda_tmp_file"
    fi
    checker check_config_miniconda
    if failure; then
        config_miniconda
    fi
    checker check_install_base_python_packages "${BASE_PACKAGES[@]}"
    if failure ; then
        install_base_python_packages "${BASE_PACKAGES[@]}"
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

download_miniconda() {
    local -r miniconda_installer_file="$1"
    download_file https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh "$miniconda_installer_file"
}

config_miniconda() {
    echo config_miniconda
    #https://docs.anaconda.com/anaconda/install/silent-mode/
    eval "$("${MINICONDA_DIR}/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
    conda init
    conda info
}

check_config_miniconda() {
    check_command_in_new_env conda
}

install_base_python_packages(){
    conda install -y -c conda-forge -n base "${BASE_PACKAGES[@]}"
}

check_install_base_python_packages(){
    local packages=( "$@" )
    for package in "${packages[@]}"; do
        check_command_in_new_env "$package"
    done
}
