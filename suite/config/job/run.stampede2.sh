#!/bin/bash
# sbatch
#SBATCH --job-name={{ job_name }}
#SBATCH --dependency==singleton
#SBATCH --partition={{ queue }}
# skx-normal: 196GB 48 cores
#SBATCH --nodes={{ nodes }}
#SBATCH --ntasks-per-node={{ mpi }}
#SBATCH --cpus-per-task={{ omp }}
#SBATCH --time={{ hour }}:00:00
#SBATCH --account=TG-AST140023
#SBATCH --output=run.log
#SBATCH --mail-type=all
#SBATCH --mail-user=qobilidop@gmail.com
#SBATCH --workdir=.
# Reference: https://portal.tacc.utexas.edu/user-guides/stampede2#job-scripts
set -e
cd ..
pwd
source "$GIZENV_ACTIVATE"

export OMP_NUM_THREADS={{ omp }}
OPT="tacc_affinity"

date
if [[ -d output/restartfiles ]]; then
    # Restart
    ibrun $OPT ./GIZMO gizmo_params.txt 1
else
    # Start from scratch
    ibrun $OPT ./GIZMO gizmo_params.txt
fi
date
