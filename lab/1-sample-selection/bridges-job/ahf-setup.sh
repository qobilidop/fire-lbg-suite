#!/usr/bin/env bash
#SBATCH -J ahf-setup
#SBATCH -p RM
#SBATCH -N 1
#SBATCH --ntasks-per-node=28
#SBATCH -t 1:00:00
#SBATCH --export=ALL
#SBATCH -o "%x.%j.log"
set -e

cd "$PROJECT_DIR"
source env/activate
check-local-env bridges

date
./lab/1-sample-selection/script/ahf-setup.py
date
