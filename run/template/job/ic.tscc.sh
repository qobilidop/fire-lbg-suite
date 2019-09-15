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
spack env activate fire-lbg-suite
set -x
cd ic
pwd

export OMP_NUM_THREADS={{ job.ic.omp }}

date
MUSIC music.conf
date
