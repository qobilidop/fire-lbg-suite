#!/usr/bin/env bash
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -v ENV_ACTIVATE,HALO
#PBS -d .
set -e
module list
eval "$ENV_ACTIVATE"
set -x
pwd
date
date_start="$(date)"

export OMP_NUM_THREADS=16

./script/track-zoom-region.py "$HALO"

echo "$date_start"
date
