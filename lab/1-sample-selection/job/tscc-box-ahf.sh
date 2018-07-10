#!/usr/bin/env bash
#PBS -N box-ahf
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -V

cd "$PROJECT_DIR"
source bin/activate

./code/script/box-ahf.py
