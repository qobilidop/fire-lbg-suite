#!/bin/bash
# This script is adapted from the sample batch script for OpenMP job at
# https://www.psc.edu/bridges/user-guide/running-jobs
#SBATCH --job-name={{ meta.name }}-music
#SBATCH --export=ALL
#SBATCH --partition=RM
#SBATCH --nodes=1
#SBATCH --ntasks-per-node={{ music.job.omp_threads }}
#SBATCH --time={{ music.job.time }}
# Make sure the job is submitted as job/music.sh to get the right workdir
#SBATCH --workdir=.
#SBATCH --output=job/music.%j.log

set -x
cd ic

export OMP_NUM_THREADS=$SLURM_NTASKS
./music/MUSIC music.conf
