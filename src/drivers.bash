##!/usr/bin/env bash
set -euxo pipefail
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set -ex

sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo ubuntu-drivers autoinstall
