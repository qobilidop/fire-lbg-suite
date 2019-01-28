#!/bin/bash
# This script is adapted from
# https://www.psc.edu/bridges/user-guide/sample-batch-scripts#openmp
#SBATCH --export=ALL
#SBATCH --partition=RM
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --workdir=.
#SBATCH --output=gen-ic.log

set -x
cd ../initial-condition
pwd
source gizenv-activate.sh

export OMP_NUM_THREADS=$SLURM_NTASKS

date
MUSIC music.conf
date
