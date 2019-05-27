#!/usr/bin/env bash
#PBS -N box-ahf
#PBS -q condo
#PBS -l nodes=8:ppn=16:ib
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o job/box-ahf.log
#PBS -v ENV_ACTIVATE
#PBS -d .
set -e
module list
eval "$ENV_ACTIVATE"
set -x
cd box/ahf
pwd
date
date_start="$(date)"

export OMP_NUM_THREADS=4

mpirun -v -machinefile "$PBS_NODEFILE" -npernode 4 -x PATH AHF snapshot_005.input

echo "$date_start"
date
