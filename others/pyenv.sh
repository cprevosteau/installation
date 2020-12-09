##!/usr/bin/env bash
set -ex

echo Installation of miniconda and essential packages
OTHERS_INSTALLATION_DIR=`dirname "$(readlink -f "$0")"`
echo Installation directory : $OTHERS_INSTALLATION_DIR
source "$OTHERS_INSTALLATION_DIR/../env.sh"

echo Install prerequisites
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

PYENV_DIR="$APP_DIR/pyenv"
git clone https://github.com/pyenv/pyenv.git "$PYENV_DIR"
echo "export PYENV_ROOT=$PYENV_DIR" >> "$BASHRC_FILE"
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$BASHRC_FILE"
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> "$BASHRC_FILE"
