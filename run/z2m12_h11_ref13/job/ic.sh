#!/bin/bash
#PBS -N h11-ic
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o job/ic.log
#PBS -d .
set -e
module list
eval "$ENV_ACTIVATE"
set -x
cd ic
pwd
date
date_start="$(date)"

export OMP_NUM_THREADS=16

MUSIC music.conf

echo "$date_start"
date
