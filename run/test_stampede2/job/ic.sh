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
spack env activate fire-lbg-suite
set -x
cd ic
pwd

export OMP_NUM_THREADS=48

date
MUSIC music.conf
date
