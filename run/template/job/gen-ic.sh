#!/bin/bash
# This job is to submit on TSCC.
#PBS -q pdafm
#PBS -l nodes=1:ppn=32
#PBS -l walltime=1:00:00
#PBS -j oe
#PBS -o gen-ic.log
#PBS -V
#PBS -d .
set -x
cd ../initial-condition
pwd
source gizenv-activate.sh

export OMP_NUM_THREADS=32

date
MUSIC music.conf
date
