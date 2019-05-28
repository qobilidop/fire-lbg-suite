#!/bin/bash
#PBS -N {{ halo_name }}-ic
#PBS -q {{ job.ic.queue }}
#PBS -l nodes=1:ppn={{ job.ic.omp }}
#PBS -l walltime={{ job.ic.hour }}:00:00
#PBS -j oe
#PBS -o job/ic.log
#PBS -d .
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
