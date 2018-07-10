#!/usr/bin/env bash
#SBATCH -J box-ahf
#SBATCH -p RM
#SBATCH -N 1
#SBATCH --ntasks-per-node=28
#SBATCH -t 4:00:00
#SBATCH --export=ALL
#SBATCH -o "%x.%j.log"
set -x

cd "$PROJECT_DIR"
source env/activate

./code/script/box-ahf.py
