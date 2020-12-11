##!/usr/bin/env bash
set -euxo pipefail
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo Add conda init to bashrc
eval "$(${MINICONDA_DIR}'/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
conda init
