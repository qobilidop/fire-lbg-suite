#!/usr/bin/env bash
set -e

if [ -z "$PROJECT_ROOT" ]; then
    echo "PROJECT_ROOT is not set. Activate first:"
    echo ">>> source env/activate"
    exit
fi
cd "$PROJECT_ROOT"
source env/activate

echo "Initializing conda env"
source env/enable-conda
conda env create -f env/environment.yml -p "$PROJECT_CONDA"
source env/activate
if [ ! -z "$GALENV_MPICC" ]; then
    # Install mpi4py using local MPI
    env MPICC="$GALENV_MPICC" pip install mpi4py
fi
(
    cd code
    pip install -e .
)
conda clean -ay
