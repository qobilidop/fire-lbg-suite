#!/bin/bash
# sbatch job/run.sh
# https://portal.tacc.utexas.edu/user-guides/stampede2#job-scripts
#SBATCH -J h00-run
#SBATCH -d singleton
#SBATCH -p skx-normal
#SBATCH -N 32
#SBATCH --ntasks-per-node=24
#SBATCH --cpus-per-task=2
#SBATCH -t 48:00:00
#SBATCH -o job/run.log
#SBATCH -D .
set -e
spack env activate gizmo
set -x

export OMP_NUM_THREADS=2
MPIRUN="ibrun tacc_affinity"
if [[ -d output/restartfiles ]]; then
    RESTART_FLAG=1
else
    RESTART_FLAG=
fi

pwd
date
eval "$MPIRUN" ./GIZMO gizmo_params.txt "$RESTART_FLAG"
date
