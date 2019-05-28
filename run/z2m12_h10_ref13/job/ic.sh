#!/bin/bash
#SBATCH -J h10-ic
#SBATCH -p RM
#SBATCH -N 1
#SBATCH --ntasks-per-node=28
#SBATCH -t 48:00:00
#SBATCH -o job/ic.log
#SBATCH -D .
set -e
module list
eval "$ENV_ACTIVATE"
set -x
cd ic
pwd
date
date_start="$(date)"

export OMP_NUM_THREADS=28

MUSIC music.conf

echo "$date_start"
date
