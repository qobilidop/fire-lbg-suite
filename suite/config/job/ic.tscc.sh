#!/bin/bash
# qsub
#PBS -N {{ job_name }}
#PBS -q {{ queue }}
#PBS -l nodes=1:ppn={{ omp }}
#PBS -l walltime={{ hour }}:00:00
#PBS -j oe
#PBS -o ic.log
#PBS -V
#PBS -d .
set -e
cd ../ic
pwd
source "$GIZENV_ACTIVATE"

export OMP_NUM_THREADS={{ omp }}

date
MUSIC music.conf
date
