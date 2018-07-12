#!/usr/bin/env bash
#PBS -N ahf-run
#PBS -q condo
#PBS -l nodes=4:ppn=16
#PBS -l walltime=08:00:00
#PBS -V
set -e

cd "$PROJECT_DIR"
source env/activate
check-local-env tscc

cd data/box-halo/ahf
export OMP_NUM_THREADS=8
MPI_OPT="-v -machinefile "$PBS_NODEFILE" -np 8"
mpirun $MPI_OPT AHF-dmo-mpi snapshot_005.input
