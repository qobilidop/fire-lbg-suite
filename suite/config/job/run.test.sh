#!/bin/bash
# bash
# job_name: {{ job_name }}
# queue: {{ queue }}
# nodes: {{ nodes }}
# omp: {{ omp }}
# mpi: {{ mpi }}
# cores: {{ cores }}
# hour: {{ hour }}
# n_file: {{ n_file }}
# time: {{ time }}
# mem: {{ mem }}
# buf: {{ buf }}
set -e
cd ..
pwd
source "$GIZENV_ACTIVATE"

export OMP_NUM_THREADS={{ omp }}
OPT="-npernode {{ mpi }}"

date
if [[ -d output/restartfiles ]]; then
    # Restart
    mpirun $OPT ./GIZMO gizmo_params.txt 1
else
    # Start from scratch
    mpirun $OPT ./GIZMO gizmo_params.txt
fi
date
