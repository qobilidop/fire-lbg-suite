#!/bin/bash
#PBS -N {{ NAME }}
#PBS -q {{ QUEUE }}
#PBS -l nodes={{ NODES }}:ppn={{ CORES }}:xe
#PBS -l walltime={{ HOUR }}:00:00
#PBS -j oe
#PBS -o run.log
#PBS -v GIZENV_ACTIVATE
#PBS -d .
set -e
cd ..
pwd
source "$GIZENV_ACTIVATE"

if [[ -f output/snapshot_172.hdf5 || -d output/snapdir_172 ]]; then
    echo "job finished"
    exit
else
    qsub -W depend=afterok:"$PBS_JOBID" run.sh
fi

export OMP_NUM_THREADS={{ OMP }}
OPT="-n $(( {{ NODES }} * {{ MPI }} )) -N {{ MPI }} -d {{ OMP }}"

date
if [[ -d output/restartfiles ]]; then
    # Restart
    aprun $OPT ./GIZMO gizmo_params.txt 1
else
    # Start from scratch
    aprun $OPT ./GIZMO gizmo_params.txt
fi
date
