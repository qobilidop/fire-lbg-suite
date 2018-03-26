#!/bin/bash
# This script is adapted from the sample batch script for hybrid OpenMP/MPI job at
# https://www.psc.edu/bridges/user-guide/running-jobs
#SBATCH --job-name={{ meta.name }}-gizmo
#SBATCH --export=ALL
#SBATCH --partition=RM
#SBATCH --nodes={{ gizmo.job.nodes }}
#SBATCH --ntasks-per-node={{ gizmo.job.mpi_tasks }}
#SBATCH --cpus-per-task={{ gizmo.job.omp_threads }}
#SBATCH --time={{ gizmo.job.time }}
# Make sure the job is submitted as job/gizmo.sh to get the right dir
#SBATCH --chdir=.
#SBATCH --output=job/gizmo.%j.log

set -x

# Revert the Intel MPI Library to an earlier shared memory mechanism to solve
# the Intel MPI Library 2018 issue.
export I_MPI_SHM_LMT=shm

export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0

MPI_OPT="-print-rank-map -n $SLURM_NTASKS -ppn $SLURM_NTASKS_PER_NODE"
MPI_OPT="$MPI_OPT -genv OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK"
MPI_OPT="$MPI_OPT -genv I_MPI_PIN_DOMAIN=omp"
if [ -d output/restartfiles ]; then
    # Restart
    mpirun $MPI_OPT ./gizmo/GIZMO gizmo_params.txt 1
else
    # Start from scratch
    mpirun $MPI_OPT ./gizmo/GIZMO gizmo_params.txt
fi

# Use this file to mark this run as finished.
touch output/finished
