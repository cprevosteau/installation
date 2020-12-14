##!/usr/bin/env bash
set -euxo pipefail
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set -ex

NEW_UBUNTU_INSTALLATION_DIR=$(dirname "$(readlink -f "$0")")
echo Installation for new ubuntu directory : ${NEW_UBUNTU_INSTALLATION_DIR}
source "${NEW_UBUNTU_INSTALLATION_DIR}/../env.sh"
source "${NEW_UBUNTU_INSTALLATION_DIR}/explorer.sh"
