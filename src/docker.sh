##!/usr/bin/env bash
set -euxo pipefail
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

DOCKER_DIR="${SYSTEM_DIR}/docker"
echo Remove old docker and install dependencies
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

echo Add Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

echo Install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io


DOCKER_DAEMON_DIR="/etc/docker"
ORIGINAL_DATA_DIR="/var/lib/docker"
echo Set docker directory : ${DOCKER_DIR}
sudo systemctl stop docker.socket
sudo systemctl stop docker
sudo rm -rf "${ORIGINAL_DATA_DIR}"
echo "{\"data-root\": \"${DOCKER_DIR}\"}" | sudo tee -a "${DOCKER_DAEMON_DIR}/daemon.json" >/dev/null
sudo cat "${DOCKER_DAEMON_DIR}/daemon.json"
sudo systemctl start docker.socket
sudo systemctl start docker

#Test
#Clean up
#sudo systemctl stop docker.socket && sudo systemctl stop docker sudo apt-get remove -y --purge docker-* containerd* \
# && sudo rm -rf /etc/docker/ && sudo rm -rf /var/lib/docker && sudo apt autoremove -y
