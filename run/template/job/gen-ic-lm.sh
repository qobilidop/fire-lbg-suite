#!/bin/bash
# This job is to submit on TSCC.
#PBS -q pdafm
#PBS -l nodes=1:ppn=16
#PBS -l walltime=1:00:00
#PBS -j oe
#PBS -o gen-ic-lm.log
#PBS -V
#PBS -d .
set -e
cd ../initial-condition
pwd
source gizenv-activate.sh

export OMP_NUM_THREADS=16

date
MUSIC music.conf
date
