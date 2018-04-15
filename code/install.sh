#!/usr/bin/env bash

# Set working directory
cd $(dirname $0)

# Ensure conda base env
source activate

# Build conda packages
./conda/build-channel.sh

# Create conda environment
# https://conda.io/docs/commands/env/conda-env-create.html
conda env create -f environment.yml -p $PWD/conda/env -q --force
