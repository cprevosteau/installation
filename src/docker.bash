##!/usr/bin/env bash
set -euxo pipefail

remove_old_docker_install() {
  echo Remove old docker and install dependencies
  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
}

install_docker_package() {
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
}

configure_data_docker() {
  local -r docker_dir="${SYSTEM_DIR}/docker"
  local -r docker_daemon_dir="/etc/docker"
  local -r original_data_dir="/var/lib/docker"
  echo "Set docker directory : ${docker_dir}"
  sudo systemctl stop docker.socket
  sudo systemctl stop docker
  sudo rm -rf "${original_data_dir}"
  echo "{\"data-root\": \"${docker_dir}\"}" | sudo tee -a "${docker_daemon_dir}/daemon.json" >/dev/null
  sudo cat "${docker_daemon_dir}/daemon.json"
  sudo systemctl start docker.socket
  sudo systemctl start docker
}

add_user_to_docker_group() {
  sudo groupadd docker
  sudo usermod -aG docker "${USER}"
  echo "You need to log out (and log in) to be able to use docker."
}

install_docker() {
  remove_old_docker_install
  install_docker_package
  configure_data_docker
}

#Test
#Clean up
#sudo systemctl stop docker.socket && sudo systemctl stop docker sudo apt-get remove -y --purge docker-* containerd* \
# && sudo rm -rf /etc/docker/ && sudo rm -rf /var/lib/docker && sudo apt autoremove -y
