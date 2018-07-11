#!/usr/bin/env bash
set -e

source enable-conda
conda activate "$LOCAL_CONDA_PREFIX"
conda install -y gcc mpi
conda install -y fftw gsl hdf5
