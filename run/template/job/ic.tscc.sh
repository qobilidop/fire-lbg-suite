#!/bin/bash
#PBS -N {{ NAME }}
#PBS -q {{ QUEUE }}
#PBS -l nodes=1:ppn={{ OMP }}
#PBS -l walltime={{ HOUR }}:00:00
#PBS -j oe
#PBS -o ic.log
#PBS -V
#PBS -d .
set -e
cd ../ic
pwd
source gizenv-activate.sh

export OMP_NUM_THREADS=$PBS_NP

date
MUSIC music.conf
date
