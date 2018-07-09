#!/usr/bin/env bash

cd "$PROJECT_DIR"
source bin/activate

source enable-conda
conda env create -f environment.yml -p "$LOCAL_DIR"

./env/"$LOCAL_ENV"/init.sh
