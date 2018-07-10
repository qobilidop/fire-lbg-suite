#!/usr/bin/env bash

set -e

echo "We're at $PROJECT_DIR"
cd "$PROJECT_DIR"
source env/activate

echo "Create conda env"
source enable-conda
conda env create -f env/environment.yml -p "$LOCAL_DIR"
source env/activate

echo "Install local Python package"
cd code
pip install -e .
cd -

echo "Initialize local env: $LOCAL_ENV"
./env/"$LOCAL_ENV"/init.sh

echo "Install external code"
echo "Install AHF"
./code/extern/ahf/install.sh
