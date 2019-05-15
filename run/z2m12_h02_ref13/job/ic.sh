#!/bin/bash
# qsub job/ic.sh
# https://www.sdsc.edu/support/user_guides/tscc.html
#PBS -N h02-ic
#PBS -q pdafm
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o ic.log
#PBS -d .
set -e
spack env activate gizmo
set -x

export OMP_NUM_THREADS=16

cd ic
pwd
date
MUSIC music.conf
date
