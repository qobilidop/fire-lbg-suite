HALO = h00
IC_TYPE = box
SIM_TYPE = hyd
REF_LVL = 11

include ../template/Makefile.config

JOB_IC_SCRIPT = ic.bridges.sh
JOB_IC_SUBMIT = sbatch -J
JOB_IC_QUEUE = RM-small
JOB_IC_OMP = 28
JOB_IC_HOUR = 1
JOB_RUN_SCRIPT = run.bridges.sh
JOB_RUN_SUBMIT = sbatch -J
JOB_RUN_QUEUE = RM-small
JOB_RUN_NODES = 2
JOB_RUN_OMP = 2
JOB_RUN_MPI = 14
JOB_RUN_HOUR = 8
JOB_RUN_TIME = 33000
JOB_RUN_MEM = 8000
JOB_RUN_BUF = 200

include ../template/Makefile
