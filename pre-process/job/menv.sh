#!/usr/bin/env bash
#PBS -N menv
#PBS -q condo
#PBS -l nodes=4:ppn=16:ib
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o job/menv.log
#PBS -d .
set -e
module list
spack env status
conda env list
set -x
pwd
date

export OMP_NUM_THREADS=4

mpirun -v -machinefile "$PBS_NODEFILE" -npernode 4 ./script/measure-menv.py

date
