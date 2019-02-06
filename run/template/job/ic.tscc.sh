#!/bin/bash
# Free options:
# -N
# -q (conda or pdafm)
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
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
