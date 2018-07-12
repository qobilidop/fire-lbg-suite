#!/usr/bin/env bash
set -e

source enable-conda
conda activate "$LOCAL_CONDA_PREFIX"
conda install -y gcc openmpi
conda install -y fftw=3 gsl hdf5
