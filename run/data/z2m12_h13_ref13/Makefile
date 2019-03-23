HALO = h13
IC_TYPE = box
SIM_TYPE = hyd
REF_LVL = 13

TMPL_DIR = ../../template
include $(TMPL_DIR)/Makefile.config

# Generate IC on TSCC
JOB_IC_SCRIPT = ic.tscc.sh
JOB_IC_SUBMIT = qsub
JOB_IC_QUEUE = pdafm
JOB_IC_OMP = 32
JOB_IC_HOUR = 24

include $(TMPL_DIR)/Makefile
