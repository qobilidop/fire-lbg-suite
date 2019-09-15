#!/bin/bash
#SBATCH -J h00-ic
#SBATCH -p RM-small
#SBATCH -N 1
#SBATCH --ntasks-per-node=28
#SBATCH -t 8:00:00
#SBATCH -o job/ic.log
#SBATCH -D .
set -e
module list
spack env activate fire-lbg-suite
set -x
cd ic
pwd

export OMP_NUM_THREADS=28

date
MUSIC music.conf
date
