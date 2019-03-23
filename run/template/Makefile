# Set derived parameters
JOB_RUN_CORES = $$(( $(JOB_RUN_MPI) * $(JOB_RUN_OMP) ))

GIZMO_DIR = gizmo_hg
CONFIG_DIR = $(TMPL_DIR)/../config

.PHONY: help
help:
	@echo 'These commands are available:'
	@echo 'init: Prepare auxiliary files and compile GIZMO'
	@echo 'submit-ic: Submit IC generation job'
	@echo 'submit-run: Submit simulation run job'
	@echo 'purge: Purge all files except for this Makefile'

.PHONY: init files compile
init: files compile
files: README
README: $(TMPL_DIR)/README
	cp -f $< $@
ic job:
	mkdir -p $@

# GIZMO compiling
compile: GIZMO
GIZMO: $(GIZMO_DIR) gizmo_config.sh
	cp $(GIZENV_ROOT)/config/package/gizmo/Makefile.systype $</Makefile.systype
	cp gizmo_config.sh $</Config.sh
	cd $< && make
	mv $</GIZMO $@

# GIZMO-related files
files: $(GIZMO_DIR) gizmo_config.sh gizmo_params.txt output_scale_factors.txt
$(GIZMO_DIR):
	hg clone $(GIZMO_REPO) -r $(GIZMO_COMMIT) $@
gizmo_config.sh: $(CONFIG_DIR)/gizmo/config/$(SIM_TYPE).sh
	cp -f $< $@
	perl -p -i -e "s/{{ OPENMP }}/$(JOB_RUN_OMP)/g" $@
gizmo_params.txt: $(CONFIG_DIR)/gizmo/params.txt
	cp -f $< $@
	perl -p -i -e "s/{{ NumFilesPerSnapshot }}/$(SNAP_FILES)/g" $@
	perl -p -i -e "s/{{ TimeLimitCPU }}/$(JOB_RUN_TIME)/g" $@
	perl -p -i -e "s/{{ MaxMemSize }}/$(JOB_RUN_MEM)/g" $@
	perl -p -i -e "s/{{ BufferSize }}/$(JOB_RUN_BUF)/g" $@
output_scale_factors.txt: $(CONFIG_DIR)/gizmo/output/scale-factors.txt
	cp -f $< $@

# Cooling-related files
ifeq ($(SIM_TYPE),hyd)
files: spcool_tables TREECOOL
spcool_tables:
	curl http://www.tapir.caltech.edu/~phopkins/public/spcool_tables.tgz | tar xvz
TREECOOL: | $(GIZMO_DIR)
	ln -nsf $(GIZMO_DIR)/cooling/TREECOOL $@
endif

# IC-related files
files: ic/music.conf ic/region_point.txt
ic/music.conf: $(CONFIG_DIR)/initial-condition/zoom.conf | ic
	cp -f $< $@
	perl -p -i -e "s/{{ levelmax }}/$(REF_LVL)/g" $@
	perl -p -i -e "s/{{ baryons }}/$(HAS_BARYONS)/g" $@
ic/region_point.txt: $(CONFIG_DIR)/initial-condition/zoom-region/$(ZOOM_REGION) | ic
	cp -f $< $@

# Jobs
.PHONY: submit-ic submit-run
files: job/ic.sh job/run.sh
submit-ic: job/ic.sh
	cd job && $(JOB_IC_SUBMIT) ic.sh
job/ic.sh: $(TMPL_DIR)/job/$(JOB_IC_SCRIPT) | job
	cp -f $< $@
	perl -p -i -e "s/{{ NAME }}/$(JOB_NAME)-ic/g" $@
	perl -p -i -e "s/{{ QUEUE }}/$(JOB_IC_QUEUE)/g" $@
	perl -p -i -e "s/{{ OMP }}/$(JOB_IC_OMP)/g" $@
	perl -p -i -e "s/{{ HOUR }}/$(JOB_IC_HOUR)/g" $@
submit-run: job/run.sh
	cd job && $(JOB_RUN_SUBMIT) run.sh
job/run.sh: $(TMPL_DIR)/job/$(JOB_RUN_SCRIPT) | job
	cp -f $< $@
	perl -p -i -e "s/{{ NAME }}/$(JOB_NAME)/g" $@
	perl -p -i -e "s/{{ QUEUE }}/$(JOB_RUN_QUEUE)/g" $@
	perl -p -i -e "s/{{ NODES }}/$(JOB_RUN_NODES)/g" $@
	perl -p -i -e "s/{{ CORES }}/$(JOB_RUN_CORES)/g" $@
	perl -p -i -e "s/{{ MPI }}/$(JOB_RUN_MPI)/g" $@
	perl -p -i -e "s/{{ OMP }}/$(JOB_RUN_OMP)/g" $@
	perl -p -i -e "s/{{ HOUR }}/$(JOB_RUN_HOUR)/g" $@

# Other commands
.PHONY: clean purge
clean:
	cd $(GIZMO_DIR) && make clean
	cd ic && rm -rf *.bin input_powerspec.txt
purge:
	rm -rf */
	find . -not -name 'Makefile' -delete
