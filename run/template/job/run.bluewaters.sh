#!/bin/bash
#PBS -N {{ NAME }}
#PBS -q {{ QUEUE }}
#PBS -l nodes={{ NODES }}:ppn={{ CORES }}:xe
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
OPT="-N {{ MPI }} -d {{ OMP }}"

date
if [[ -d output/restartfiles ]]; then
    # Restart
    aprun $OPT ./GIZMO gizmo_params.txt 1
else
    # Start from scratch
    aprun $OPT ./GIZMO gizmo_params.txt
fi
date
