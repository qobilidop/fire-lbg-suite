#!/usr/bin/env bash

set -e

source enable-conda
conda activate "$LOCAL_DIR"
conda install -y gcc
