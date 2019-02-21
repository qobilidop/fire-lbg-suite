HALO = h13
SIM_TYPE = hyd
REF_LVL = 13

include ../template/Makefile.config
# Use box IC for the pilot run
ZOOM_REGION = $(HALO)-box-rad4.txt
# Generate IC on TSCC for larger memory
JOB_IC_SCRIPT = ic.tscc.sh
JOB_IC_SUBMIT = qsub -q pdafm -N
JOB_IC_OMP = 32
include ../template/Makefile
