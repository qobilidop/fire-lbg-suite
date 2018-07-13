#!/usr/bin/env bash
#SBATCH -J ahf-run
#SBATCH -p RM
#SBATCH -N 2
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=7
#SBATCH -t 8:00:00
#SBATCH --export=ALL
#SBATCH -o "%x.%j.log"
set -e

cd "$PROJECT_DIR"
source env/activate
check-local-env bridges

cd data/box-ahf
export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0
MPI_OPT="-print-rank-map -n $SLURM_NTASKS -ppn $SLURM_NTASKS_PER_NODE"
MPI_OPT="$MPI_OPT -genv OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK"
MPI_OPT="$MPI_OPT -genv I_MPI_PIN_DOMAIN=omp"
mpirun $MPI_OPT AHF-dmo-mpi snapshot_005.input
