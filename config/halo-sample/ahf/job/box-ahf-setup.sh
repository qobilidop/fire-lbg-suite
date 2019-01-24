#!/usr/bin/env bash
#PBS -N box-ahf-setup
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o box-ahf-setup.log
#PBS -V
#PBS -d .
set -e
source "$PROJECT_ACTIVATE"
cd ..
echo "$PWD"

date
export OMP_NUM_THREADS=16
ahf-setup.py -s ../output/snapdir_005/snapshot_005.0.hdf5
date
