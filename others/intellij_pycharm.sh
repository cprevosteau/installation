##!/usr/bin/env bash
set -ex

echo Installation of Intellij
OTHERS_INSTALLATION_DIR=`dirname "$(readlink -f "$0")"`
echo Installation directory : $OTHERS_INSTALLATION_DIR
source "$OTHERS_INSTALLATION_DIR/../env.sh"

wget -O- "https://download.jetbrains.com/idea/ideaIC-2020.3.tar.gz" | tar -xz --directory "$APP_DIR"
