#!/usr/bin/env bash
# qsub job/box-ahf-run.sh
#PBS -N box-ahf-run
#PBS -q condo
#PBS -l nodes=4:ppn=16:ib
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o job/box-ahf-run.log
#PBS -d .
set -e
spack env activate gizmo
set -x

export OMP_NUM_THREADS=4
MPIRUN="mpirun -machinefile $PBS_NODEFILE -npernode 4"

cd data/box/ahf
pwd
date
eval "$MPIRUN" AHF snapshot_005.input
date
