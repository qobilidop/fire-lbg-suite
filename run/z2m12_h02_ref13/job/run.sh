#!/bin/bash
# sbatch job/run.sh
#SBATCH -J h02-run
#SBATCH -d singleton
#SBATCH -p skx-normal
#SBATCH -N 128
#SBATCH --ntasks-per-node=24
#SBATCH --cpus-per-task=2
#SBATCH -t 48:00:00
#SBATCH -o job/run.log
#SBATCH -D .
set -e
module list
spack env activate gizmo
spack env status
set -x
pwd
date

export OMP_NUM_THREADS=2
MPIRUN="ibrun"
if [[ -d output/restartfiles ]]; then
    RESTART_FLAG=1
else
    RESTART_FLAG=2
fi

eval "$MPIRUN" ./GIZMO gizmo_params.txt "$RESTART_FLAG"

date
