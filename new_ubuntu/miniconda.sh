##!/usr/bin/env bash
echo Add conda init to bashrc
eval "$($MINICONDA_DIR'/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
conda init
