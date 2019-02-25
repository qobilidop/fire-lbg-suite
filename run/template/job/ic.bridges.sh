#!/bin/bash
# Free options:
# -J
#SBATCH -p RM-small
#SBATCH --nodes=1
#SBATCH --ntasks-per-node={{ OMP_THREADS }}
#SBATCH --cpus-per-task=1
#SBATCH --time=8:00:00
#SBATCH --output=ic.log
#SBATCH --export=ALL
#SBATCH --workdir=.
# Reference: https://www.psc.edu/bridges/user-guide/sample-batch-scripts#openmp
set -e
cd ../ic
pwd
source gizenv-activate.sh

export OMP_NUM_THREADS=$SLURM_NTASKS

date
MUSIC music.conf
date
