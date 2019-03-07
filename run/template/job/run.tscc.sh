#!/bin/bash
#PBS -N {{ NAME }}
#PBS -q {{ QUEUE }}
#PBS -l nodes={{ NODES }}:ppn={{ CORES }}:ib
#PBS -l walltime={{ HOUR }}:00:00
#PBS -j oe
#PBS -o run.log
#PBS -V
#PBS -d .
set -e
cd ..
pwd
source gizenv-activate.sh

export OMP_NUM_THREADS={{ OMP }}
OPT="-v -machinefile $PBS_NODEFILE -npernode {{ MPI }} -x LD_LIBRARY_PATH"

date
if [[ -d output/restartfiles ]]; then
    # Restart
    mpirun $OPT ./GIZMO gizmo_params.txt 1
else
    # Start from scratch
    mpirun $OPT ./GIZMO gizmo_params.txt
fi
date
