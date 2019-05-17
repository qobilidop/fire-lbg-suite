#!/usr/bin/env bash
# qsub job/box-ahf.sh
# https://www.sdsc.edu/support/user_guides/tscc.html#submit-job
#PBS -N box-ahf-run
#PBS -q condo
#PBS -l nodes=4:ppn=16:ib
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o job/box-ahf.log
#PBS -V
#PBS -d .
set -e
spack env activate gizmo
spack env status
set -x

export OMP_NUM_THREADS=4
MPIRUN="mpirun -v -machinefile $PBS_NODEFILE -npernode 4 -x PATH"

cd data/box/ahf
pwd
date
eval "$MPIRUN" AHF snapshot_005.input
date
