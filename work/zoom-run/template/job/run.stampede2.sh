#!/bin/bash
# sbatch job/run.sh
# https://portal.tacc.utexas.edu/user-guides/stampede2#job-scripts
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
spack env activate gizmo
set -x

export OMP_NUM_THREADS={{ job.run.omp }}
MPIRUN="ibrun tacc_affinity"
if [[ -d output/restartfiles ]]; then
    RESTART_FLAG=1
else
    RESTART_FLAG={{ 2 if gizmo.InitCondFile is defined }}
fi

pwd
date
eval "$MPIRUN" ./GIZMO gizmo_params.txt "$RESTART_FLAG"
date
