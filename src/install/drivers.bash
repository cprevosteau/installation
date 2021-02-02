##!/usr/bin/env bash
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

install_drivers() {
    sudo add-apt-repository -y ppa:graphics-drivers/ppa
    sudo apt-get update
    sudo ubuntu-drivers autoinstall
}

check_drivers() {
    local gpu_driver
    gpu_driver="$(prime-select query)"
    [[ "$gpu_driver" == "nvidia" ]]
}
