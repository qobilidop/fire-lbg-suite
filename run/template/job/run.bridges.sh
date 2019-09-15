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
spack env activate fire-lbg-suite
set -x
pwd

export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0
MPIRUN="mpirun -n $SLURM_NTASKS -ppn {{ job.run.mpi }} -genv OMP_NUM_THREADS={{ job.run.omp }} -genv I_MPI_PIN_DOMAIN=omp"
if [[ -d output/restartfiles ]]; then
    RESTART_FLAG=1
else
    RESTART_FLAG={{ 2 if gizmo.InitCondFile is defined }}
fi

date
eval "$MPIRUN" ./GIZMO gizmo_params.txt "$RESTART_FLAG"
date
