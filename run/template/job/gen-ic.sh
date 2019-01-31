#!/bin/bash
# This job is to submit on Bridges.
# The script is adapted from
# https://www.psc.edu/bridges/user-guide/sample-batch-scripts#openmp
#SBATCH --partition=RM-small
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --output=gen-ic.log
#SBATCH --export=ALL
#SBATCH --workdir=.
set -e
cd ../initial-condition
pwd
source gizenv-activate.sh

export OMP_NUM_THREADS=$SLURM_NTASKS

date
MUSIC music.conf
date
