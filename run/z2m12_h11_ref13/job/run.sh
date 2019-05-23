#!/bin/bash
# sbatch job/run.sh
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
module list
spack env activate gizmo
spack env status
set -x
pwd
date

export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0
MPIRUN="mpirun -n $SLURM_NTASKS -ppn 14 -genv OMP_NUM_THREADS=2 -genv I_MPI_PIN_DOMAIN=omp"
if [[ -d output/restartfiles ]]; then
    RESTART_FLAG=1
else
    RESTART_FLAG=
fi

eval "$MPIRUN" ./GIZMO gizmo_params.txt "$RESTART_FLAG"

date
