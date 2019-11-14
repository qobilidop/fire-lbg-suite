#!/bin/bash
#SBATCH -J h11-run
#SBATCH -d singleton
#SBATCH -p skx-normal
#SBATCH -N 128
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=4
#SBATCH -t 48:00:00
#SBATCH -o job/run.log
#SBATCH -D .
set -e
module list
spack env activate fire-lbg-suite
set -x
pwd

export OMP_NUM_THREADS=4
MPIRUN="ibrun"
if [[ -d output/restartfiles ]]; then
    RESTART_FLAG=1
else
    RESTART_FLAG=
fi

date
eval "$MPIRUN" ./GIZMO gizmo_params.txt "$RESTART_FLAG"
date
