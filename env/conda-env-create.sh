#!/usr/bin/env bash

env_name="fire2-lbg"

cd "$(dirname "$0")"
conda env create -n "$env_name" -f environment.yml
. "$("$CONDA_EXE" info --root)"/etc/profile.d/conda.sh
conda activate "$env_name"
pip install -e .
