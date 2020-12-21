##!/usr/bin/env bash
include utils/download.bash

install_miniconda() {
  local -r miniconda_tmp_file="/tmp/miniconda_installer.sh"
  download_miniconda "$miniconda_tmp_file"
  install_miniconda_package "$miniconda_tmp_file"
  rm "$miniconda_tmp_file"
  config_miniconda
  install_base_python_packages
}

install_miniconda_package() {
  local -r miniconda_installer_file="$1"
  #https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html#install-macos-silent
  local miniconda_installer_options=(-b -f -p "$MINICONDA_DIR")
  sh "$miniconda_installer_file" "${miniconda_installer_options[@]}"
}

install_base_python_packages(){
    conda install -y -c conda-forge jupyterlab
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
