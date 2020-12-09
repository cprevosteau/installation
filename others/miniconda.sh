##!/usr/bin/env bash
set -ex

echo Installation of miniconda and essential packages
OTHERS_INSTALLATION_DIR=`dirname "$(readlink -f "$0")"`
echo Installation directory : $OTHERS_INSTALLATION_DIR
source "$OTHERS_INSTALLATION_DIR/../env.sh"

echo Installation de Miniconda
MINICONDA_INSTALLER_FILE="/tmp/miniconda_installer.sh"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "$MINICONDA_INSTALLER_FILE"
bash "$MINICONDA_INSTALLER_FILE" -b -f -p "$MINICONDA_DIR"
rm "$MINICONDA_INSTALLER_FILE"
cd "$NEW_UBUNTU_INSTALLATION_DIR"
source "$NEW_UBUNTU_INSTALLATION_DIR/miniconda.sh"

echo Installation de jupyterlab
conda install -y -c conda-forge jupyterlab
