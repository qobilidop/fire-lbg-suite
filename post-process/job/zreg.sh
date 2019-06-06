#!/usr/bin/env bash
#PBS -q condo
#PBS -l nodes=1:ppn=8
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -v ENV_ACTIVATE,SNAP,OUTPUT
#PBS -d .
set -e
module list
eval "$ENV_ACTIVATE"
set -x
pwd
date
date_start="$(date)"

export OMP_NUM_THREADS=8

./script/zoom-region-render.py -s "$SNAP" -o "$OUTPUT"

echo "$date_start"
date
