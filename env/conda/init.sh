#!/usr/bin/env bash
set -e

source enable-conda
conda env update -f "$PROJECT_DIR/env/conda/environment.yml" -p "$LOCAL_CONDA_PREFIX"
