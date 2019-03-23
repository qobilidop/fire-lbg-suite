HALO = h10
IC_TYPE = box
SIM_TYPE = hyd
REF_LVL = 13

TMPL_DIR = ../../template
include $(TMPL_DIR)/Makefile.config

# Run on Blue Waters
JOB_RUN_SCRIPT = run.bluewaters.sh
JOB_RUN_SUBMIT = qsub
JOB_RUN_QUEUE = normal
JOB_RUN_NODES = 64
JOB_RUN_OMP = 2
JOB_RUN_MPI = 16
JOB_RUN_HOUR = 48
JOB_RUN_TIME = 202000
JOB_RUN_MEM = 7500
JOB_RUN_BUF = 200

include $(TMPL_DIR)/Makefile
