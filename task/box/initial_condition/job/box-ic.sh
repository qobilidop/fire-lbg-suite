#!/usr/bin/env bash
#PBS -N box-ic
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=1:00:00
#PBS -j oe
#PBS -o box-ic.log
#PBS -V
#PBS -d .
set -e
source "$PROJECT_ACTIVATE"
cd ..
echo "$PWD"

date
export OMP_NUM_THREADS=16
MUSIC ic_L86_ref10.conf
date
