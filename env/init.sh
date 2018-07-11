#!/usr/bin/env bash
set -e

echo "$PROJECT_DIR"
cd "$PROJECT_DIR"
source env/activate

mkdir -p "$LOCAL_PREFIX/bin"

echo "Create conda env"
source enable-conda
conda env create -f code/environment.yml -p "$LOCAL_CONDA_PREFIX"
source env/activate

echo "Install code/src"
cd code
pip install -e .
cd -

echo "Initialize local env: $LOCAL_ENV"
./env/"$LOCAL_ENV"/init.sh

echo "Install external code"
./code/extern/install-all.sh
