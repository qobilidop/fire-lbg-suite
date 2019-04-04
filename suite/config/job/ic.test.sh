#!/bin/bash
# bash
# job_name: {{ job_name }}
# queue: {{ queue }}
# omp: {{ omp }}
# hour: {{ hour }}
set -e
cd ../ic
pwd
source "$GIZENV_ACTIVATE"

export OMP_NUM_THREADS={{ omp }}

date
MUSIC music.conf
date
