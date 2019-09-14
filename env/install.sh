#!/usr/bin/env bash
set -e

spack env create fire-lbg-suite env-spack.yaml

conda env update -f env-conda.yaml
. "$(conda info --base)"/etc/profile.d/conda.sh
conda activate fire-lbg-suite
conda env list

# Install mpi4py with system MPI
pip install mpi4py

# Install yt-4.0
conda uninstall -y yt
if [[ ! -d yt-4.0 ]]; then
    # Clone repo
    git clone https://github.com/yt-project/yt.git -b yt-4.0 --depth 1 yt-4.0
else
    # Update existing repo
    (
        cd yt-4.0
        git pull
    )
fi
(
    cd yt-4.0
    pip install -e .
)
