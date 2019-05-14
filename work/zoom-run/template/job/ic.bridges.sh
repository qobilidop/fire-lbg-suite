#!/bin/bash
# sbatch job/ic.sh
# https://www.psc.edu/bridges/user-guide/sample-batch-scripts#openmp
#SBATCH -J {{ halo_name }}-ic
#SBATCH -p {{ job.ic.queue }}
#SBATCH -N 1
#SBATCH --ntasks-per-node={{ job.ic.omp }}
#SBATCH -t {{ job.ic.hour }}:00:00
#SBATCH -o job/ic.log
#SBATCH -D .
set -e
spack env activate gizmo
set -x

export OMP_NUM_THREADS={{ job.ic.omp }}

cd ic
pwd
date
MUSIC music.conf
date
