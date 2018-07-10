#!/usr/bin/env bash

cd "$PROJECT_DIR"
source bin/activate

source enable-conda
conda env create -f environment.yml -p "$LOCAL_DIR"
source bin/activate

cd code
pip install .
cd -

./env/"$LOCAL_ENV"/init.sh

./code/install/ahf/install.sh
