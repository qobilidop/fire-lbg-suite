#!/bin/bash
# qsub job/ic.sh
# https://www.sdsc.edu/support/user_guides/tscc.html
#PBS -N {{ halo_name }}-ic
#PBS -q {{ job.ic.queue }}
#PBS -l nodes=1:ppn={{ job.ic.omp }}
#PBS -l walltime={{ job.ic.hour }}:00:00
#PBS -j oe
#PBS -o ic.log
#PBS -d .
set -e
spack env activate gizmo
set -x

export OMP_NUM_THREADS={{ job.ic.omp }}

cd ic
pwd
date
MUSIC music.conf
date
