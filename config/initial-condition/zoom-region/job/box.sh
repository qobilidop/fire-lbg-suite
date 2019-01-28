#!/usr/bin/env bash
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -V
#PBS -d .
set -e
cd ..
echo "$PWD"
source project-activate.sh

date
make "${HALO_LABEL}_box_rad4.txt"
date
