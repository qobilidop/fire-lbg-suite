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
source enable-conda
conda env create -f env/environment.yml -p "$PROJECT_CONDA"
source env/activate
if [ ! -z "$GALENV_MPICC" ]; then
    # Install mpi4py using local MPI
    env MPICC="$GALENV_MPICC" pip install mpi4py
fi
(
    # Replace yt by the dev version
    mkdir -p env/repo
    cd env/repo
    git clone https://github.com/yt-project/yt.git
    cd yt
    conda uninstall yt
    pip install -e .
)
(
    cd code
    pip install -e .
)
