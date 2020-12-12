##!/usr/bin/env bash
set -euxo pipefail
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set -ex

echo Installation of miniconda and essential packages
OTHERS_INSTALLATION_DIR=$(dirname "$(readlink -f "$0")")
echo Installation directory : "${OTHERS_INSTALLATION_DIR}"
source "${OTHERS_INSTALLATION_DIR}/../env.sh"

echo Installation de poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME="${ENCRYPTED_DIR}/app/poetry" python -
