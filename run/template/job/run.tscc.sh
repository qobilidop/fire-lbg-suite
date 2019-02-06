#!/bin/bash
# Free options:
# -N
# -l nodes=(n):ppn=16:ib
#PBS -q condo
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o run.log
#PBS -V
#PBS -d .
set -e
cd ..
pwd
source gizenv-activate.sh

export OMP_NUM_THREADS={{ OMP_THREADS }}
OPT="-v -machinefile $PBS_NODEFILE -npernode {{ MPI_TASKS }} -x LD_LIBRARY_PATH"

date
if [[ -d output/restartfiles ]]; then
    # Restart
    mpirun $OPT ./GIZMO gizmo_params.txt 1
else
    # Start from scratch
    mpirun $OPT ./GIZMO gizmo_params.txt
fi
date
