#!/usr/bin/env bash
#PBS -N ahf-setup
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=08:00:00
#PBS -V
set -e

cd "$PROJECT_DIR"
source env/activate
check-local-env tscc

./lab/1-sample-selection/script/ahf-setup.py
