#!/bin/bash
# sbatch job/run.sh
# https://www.psc.edu/bridges/user-guide/sample-batch-scripts#hybrid
#SBATCH -J h11-run
#SBATCH -d singleton
#SBATCH -p RM
#SBATCH -N 64
#SBATCH --ntasks-per-node=14
#SBATCH --cpus-per-task=2
#SBATCH -t 48:00:00
#SBATCH -o job/run.log
#SBATCH -D .
set -e
spack env activate gizmo
set -x

export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0
MPIRUN="mpirun -n $SLURM_NTASKS -ppn 14 -genv OMP_NUM_THREADS=2 -genv I_MPI_PIN_DOMAIN=omp"
if [[ -d output/restartfiles ]]; then
    RESTART_FLAG=1
else
    RESTART_FLAG=2
fi

pwd
date
eval "$MPIRUN" ./GIZMO gizmo_params.txt "$RESTART_FLAG"
date
