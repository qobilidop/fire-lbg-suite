#!/usr/bin/env bash
#PBS -N sample-plot
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o sample-plot.log
#PBS -V
#PBS -d .
set -e
source "$PROJECT_ACTIVATE"
cd ..
echo "$PWD"

date
./script/plot-sample.py
date
