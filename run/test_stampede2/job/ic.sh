#!/bin/bash
#SBATCH -J h00-ic
#SBATCH -p skx-dev
#SBATCH -N 1
#SBATCH --ntasks-per-node=48
#SBATCH -t 2:00:00
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

export OMP_NUM_THREADS=48

MUSIC music.conf

echo "$date_start"
date
