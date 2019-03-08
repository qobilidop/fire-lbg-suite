HALO = h01
IC_TYPE = box
SIM_TYPE = hyd
REF_LVL = 13

include ../template/Makefile.config

# Run on Stampede2
JOB_RUN_SCRIPT = run.stampede2.sh
JOB_RUN_SUBMIT = sbatch
JOB_RUN_QUEUE = skx-normal
JOB_RUN_NODES = 20
JOB_RUN_OMP = 2
JOB_RUN_MPI = 24
JOB_RUN_HOUR = 48
JOB_RUN_TIME = 202000
JOB_RUN_MEM = 7500
JOB_RUN_BUF = 200

include ../template/Makefile
