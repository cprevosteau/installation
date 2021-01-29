##!/usr/bin/env bash
include utils/decorators.bash


install_docker() {
  remove_old_docker_install
  install_docker_package
  add_user_to_docker_group
  set_data_root_directory "$DOCKER_ROOT_DIR"
}

check_docker() {
    command -v docker
    local actual_data_root
    actual_data_root=$(sudo docker info 2>/dev/null | grep "Docker Root Dir" | awk '(NR == 1){print $4}')
    sudo runuser -l "$USER" -c "docker run hello-world" &>/dev/null
    [[ "$actual_data_root" = "$SYSTEM_DIR/docker" ]]
}

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

add_user_to_docker_group() {
  sudo usermod -aG docker "${USER}"
  echo "You need to log out (and log in) to be able to use docker."
}

set_data_root_directory() {
    local new_docker_dir="$1"
    mkdir -p "$new_docker_dir"
    local docker_daemon_file="/etc/docker/daemon.json"
    if [ ! -f "$docker_daemon_file" ]; then
        sudo mkdir -p "$(dirname $docker_daemon_file)"
        echo '{}' | sudo tee -a "$docker_daemon_file"
    fi
    sudo systemctl stop docker.socket
    sudo systemctl stop docker
    run_with_sudo add_string_entry_to_json "data-root" "$new_docker_dir" "$docker_daemon_file"
    sudo systemctl start docker.socket
    sudo systemctl start docker
}

add_string_entry_to_json(){
    local entry="$1"
    local value="$2"
    local file="$3"
    local tmp_file="/tmp/new_json.json"
    jq ".[\"$entry\"] |= \"$value\"" "$file" > "$tmp_file"
    mv "$tmp_file" "$file"
}
