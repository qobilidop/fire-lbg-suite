#!/bin/bash
# sbatch
#SBATCH --job-name={{ job_name }}
#SBATCH --partition={{ queue }}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node={{ omp }}
#SBATCH --cpus-per-task=1
#SBATCH --time={{ hour }}:00:00
#SBATCH --output=ic.log
#SBATCH --export=ALL
#SBATCH --workdir=.
# Reference: https://www.psc.edu/bridges/user-guide/sample-batch-scripts#openmp
set -e
cd ../ic
pwd
source "$GIZENV_ACTIVATE"

export OMP_NUM_THREADS={{ omp }}

date
MUSIC music.conf
date
