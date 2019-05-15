#!/bin/bash
# qsub job/ic.sh
# https://www.sdsc.edu/support/user_guides/tscc.html
#PBS -N h13-ic
#PBS -q pdafm
#PBS -l nodes=1:ppn=32
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o job/ic.log
#PBS -d .
set -e
spack env activate gizmo
set -x

export OMP_NUM_THREADS=32

cd ic
pwd
date
MUSIC music.conf
date
