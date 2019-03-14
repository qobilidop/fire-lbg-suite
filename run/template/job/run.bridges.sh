#!/bin/bash
#SBATCH --job-name={{ NAME }}
#SBATCH --partition={{ QUEUE }}
#SBATCH --nodes={{ NODES }}
#SBATCH --ntasks-per-node={{ MPI }}
#SBATCH --cpus-per-task={{ OMP }}
#SBATCH --time={{ HOUR }}:00:00
#SBATCH --output=run.log
#SBATCH --mail-type=all
#SBATCH --export=ALL
#SBATCH --workdir=.
# Reference: https://www.psc.edu/bridges/user-guide/sample-batch-scripts#hybrid
set -e
cd ..
pwd
source "$GIZENV_ACTIVATE"

export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0
OPT="-print-rank-map -n $SLURM_NTASKS -ppn $SLURM_NTASKS_PER_NODE"
OPT="$OPT -genv OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK"
OPT="$OPT -genv I_MPI_PIN_DOMAIN=omp"

date
if [[ -d output/restartfiles ]]; then
    # Restart
    mpirun $OPT ./GIZMO gizmo_params.txt 1
else
    # Start from scratch
    mpirun $OPT ./GIZMO gizmo_params.txt
fi
date
