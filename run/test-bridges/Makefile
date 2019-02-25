HALO = h00
SIM_TYPE = hyd
REF_LVL = 11

include ../template/Makefile.config

ZOOM_REGION = $(HALO)-box-rad4.txt
JOB_IC_SCRIPT = ic.bridges.sh
JOB_IC_SUBMIT = sbatch -J
JOB_IC_OMP = 28
JOB_RUN_SCRIPT = run.bridges-test.sh
JOB_RUN_SUBMIT = sbatch --nodes=2 -J
JOB_RUN_OMP = 2
JOB_RUN_MPI = 14
JOB_RUN_TIME = 33000
JOB_RUN_MEM = 8000
JOB_RUN_BUF = 200

include ../template/Makefile
