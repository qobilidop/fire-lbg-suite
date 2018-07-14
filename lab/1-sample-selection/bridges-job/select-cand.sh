#!/usr/bin/env bash
#SBATCH -J select-cand
#SBATCH -p RM
#SBATCH -N 4
#SBATCH --ntasks-per-node=7
#SBATCH --cpus-per-task=4
#SBATCH -t 2:00:00
#SBATCH --export=ALL
#SBATCH -o "%x.%j.log"
set -e

cd "$PROJECT_DIR"
source env/activate
check-local-env bridges

MPI_OPT="-print-rank-map -n $SLURM_NTASKS -ppn $SLURM_NTASKS_PER_NODE"

date
mpirun $MPI_OPT ./lab/1-sample-selection/script/select-cand.py
date
