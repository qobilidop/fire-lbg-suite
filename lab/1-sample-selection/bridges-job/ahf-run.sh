#!/usr/bin/env bash
#SBATCH -J ahf-run
#SBATCH -p RM
#SBATCH -N 4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=7
#SBATCH -t 1:00:00
#SBATCH --export=ALL
#SBATCH -o "%x.%j.log"
set -e

cd "$PROJECT_DIR"
source env/activate
check-local-env bridges

export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0
MPI_OPT="-print-rank-map -n $SLURM_NTASKS -ppn $SLURM_NTASKS_PER_NODE"
MPI_OPT="$MPI_OPT -genv OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK"
MPI_OPT="$MPI_OPT -genv I_MPI_PIN_DOMAIN=omp"

date
cd data/box-halo/ahf
mpirun $MPI_OPT AHF-dmo-mpi snapshot_005.input
date
