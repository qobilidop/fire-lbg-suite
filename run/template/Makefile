CONFIG_DIR = ../../config

# FIRE_FrozenBranch at 2018-06-17
GIZMO_REPO = ssh://hg@bitbucket.org/phopkins/gizmo
GIZMO_COMMIT = 76dbfab6c0fbef056b713410e5eb73f8c1b00205
GIZMO_DIR = gizmo-hg
GIZMO_CONFIG = gizmo-config.sh
GIZMO_PARAMS = gizmo-params.txt

.PHONY: init
init: compile files

.PHONY: compile
compile: GIZMO
GIZMO: $(GIZMO_CONFIG)
	gizenv-compile-gizmo.py \
	--repo $(GIZMO_REPO) \
	--commit $(GIZMO_COMMIT) \
	--dir $(GIZMO_DIR) \
	--config $< \
	--bin $@

.PHONY: files
files: TREECOOL output-scale-factors.txt $(GIZMO_PARAMS)
TREECOOL: $(GIZMO_DIR)/cooling/TREECOOL compile
	ln -nsf $< $@
output-scale-factors.txt: $(CONFIG_DIR)/gizmo/output/scale-factors.txt
	cp -f $< $@
$(GIZMO_CONFIG): $(CONFIG_DIR)/gizmo/config/$(CONFIG_GIZMO_CONFIG)
	cp -f $< $@
$(GIZMO_PARAMS): $(CONFIG_DIR)/gizmo/params/$(CONFIG_GIZMO_PARAMS)
	cp -f $< $@
files: initial-condition/music.conf initial-condition/region-point.txt
initial-condition/music.conf: $(CONFIG_DIR)/initial-condition/$(CONFIG_MUSIC_CONF) | initial-condition
	cp -f $< $@
initial-condition/region-point.txt: $(CONFIG_DIR)/initial-condition/zoom-region/$(CONFIG_ZOOM_REGION) | initial-condition
	cp -f $< $@
initial-condition:
	mkdir -p $@

.PHONY: submit-ic
files: job/gen-ic.sh
submit-ic: job/gen-ic.sh
	cd job && sbatch -J $(JOB_NAME)-ic gen-ic.sh
job/gen-ic.sh: ../template/job/gen-ic.sh | job
	cp -f $< $@

.PHONY: submit-ic-lm
files: job/gen-ic-lm.sh
submit-ic-lm: job/gen-ic-lm.sh
	cd job && qsub -N $(JOB_NAME)-ic gen-ic-lm.sh
job/gen-ic-lm.sh: ../template/job/gen-ic-lm.sh | job
	cp -f $< $@

job:
	mkdir -p $@
