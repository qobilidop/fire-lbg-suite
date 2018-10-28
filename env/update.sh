#!/usr/bin/env bash
set -e
cd "$PROJECT_ROOT"

echo "Updating conda env"
source env/enable-conda
conda env update -f env/environment.yml -p "$PROJECT_CONDA"
source env/activate
conda clean -ay
