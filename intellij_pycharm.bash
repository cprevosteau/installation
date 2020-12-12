##!/usr/bin/env bash
set -euxo pipefail
readonly installation_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${installation_dir}/src/import_src_and_env.bash"
include utils.bash

wget -O- "https://download.jetbrains.com/idea/ideaIC-2020.3.tar.gz" | tar -xz --directory "${APP_DIR}"
wget -O- "https://download.jetbrains.com/python/pycharm-community-2020.3.tar.gz" | tar -xz --directory "${APP_DIR}"

include config_intellij_pypcharm.bash