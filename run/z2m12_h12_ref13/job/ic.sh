#!/bin/bash
# sbatch job/ic.sh
# https://www.psc.edu/bridges/user-guide/sample-batch-scripts#openmp
#SBATCH -J h12-ic
#SBATCH -p RM-small
#SBATCH -N 1
#SBATCH --ntasks-per-node=28
#SBATCH -t 8:00:00
#SBATCH -o job/ic.log
#SBATCH -D .
set -e
spack env activate gizmo
set -x

export OMP_NUM_THREADS=28

cd ic
pwd
date
MUSIC music.conf
date
