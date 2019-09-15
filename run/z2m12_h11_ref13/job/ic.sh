#!/bin/bash
#PBS -N h11-ic
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o job/ic.log
#PBS -d .
set -e
module list
spack env activate fire-lbg-suite
set -x
cd ic
pwd

export OMP_NUM_THREADS=16

date
MUSIC music.conf
date
