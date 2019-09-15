#!/bin/bash
#SBATCH -J {{ halo_name }}-ic
#SBATCH -p {{ job.ic.queue }}
#SBATCH -N 1
#SBATCH --ntasks-per-node={{ job.ic.omp }}
#SBATCH -t {{ job.ic.hour }}:00:00
#SBATCH -o job/ic.log
#SBATCH -D .
set -e
module list
spack env activate fire-lbg-suite
set -x
cd ic
pwd

export OMP_NUM_THREADS={{ job.ic.omp }}

date
MUSIC music.conf
date
