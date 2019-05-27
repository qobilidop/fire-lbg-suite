#!/usr/bin/env bash
#PBS -N menv
#PBS -q condo
#PBS -l nodes=8:ppn=16:ib
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o job/menv.log
#PBS -v ENV_ACTIVATE
#PBS -d .
set -e
module list
eval "$ENV_ACTIVATE"
set -x
pwd
date
date_start="$(date)"

export OMP_NUM_THREADS=4

mpirun -v -machinefile "$PBS_NODEFILE" -npernode 4 ./script/measure-menv.py

echo "$date_start"
date
