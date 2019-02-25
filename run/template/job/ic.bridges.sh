#!/bin/bash
#SBATCH --partition={{ QUEUE }}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node={{ OMP }}
#SBATCH --cpus-per-task=1
#SBATCH --time={{ HOUR }}:00:00
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
