#!/usr/bin/env bash
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -v HALO
#PBS -d .
set -e
module list
spack env status
conda env list
set -x
pwd
date

export OMP_NUM_THREADS=16

./script/track-zoom-region.py "$HALO"

date
