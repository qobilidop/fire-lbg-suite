#!/bin/bash
#SBATCH -J {{ halo_name }}-run
#SBATCH -d singleton
#SBATCH -p {{ job.run.queue }}
#SBATCH -N {{ job.run.nodes }}
#SBATCH --ntasks-per-node={{ job.run.mpi }}
#SBATCH --cpus-per-task={{ job.run.omp }}
#SBATCH -t {{ job.run.hour }}:00:00
#SBATCH -o job/run.log
#SBATCH -D .
set -e
module list
eval "$ENV_ACTIVATE"
set -x
pwd
date
date_start="$(date)"

export OMP_NUM_THREADS={{ job.run.omp }}
MPIRUN="ibrun"
if [[ -d output/restartfiles ]]; then
    RESTART_FLAG=1
else
    RESTART_FLAG={{ 2 if gizmo.InitCondFile is defined }}
fi

eval "$MPIRUN" ./GIZMO gizmo_params.txt "$RESTART_FLAG"

echo "$date_start"
date
