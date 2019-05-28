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
eval "$ENV_ACTIVATE"
set -x
cd ic
pwd
date
date_start="$(date)"

export OMP_NUM_THREADS={{ job.ic.omp }}

MUSIC music.conf

echo "$date_start"
date
