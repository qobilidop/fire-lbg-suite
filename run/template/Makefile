GIZMO_GIT_SRC = git@bitbucket.org:phopkins/gizmo.git
# commit message: Merged default into FIRE_FrozenBranch_Nov13_2015
# commit date: 2018-06-17
# original hg commit: 76dbfab6c0fbef056b713410e5eb73f8c1b00205
GIZMO_GIT_COMMIT = 46c30dab9703f13fdbfd410e3ea4941e97860aa9

.PHONY: init
init: GIZMO spcool_tables TREECOOL

GIZMO: gizmo_config.sh | gizmo_hg
	cp gizmo_config.sh gizmo_hg/Config.sh
	spack diy -d gizmo_hg -n gizmo@local && eval `spack env deactivate --sh` && spack uninstall -y gizmo@local
	ln -s gizmo_hg/GIZMO $@

gizmo_hg:
	hg clone $(GIZMO_HG_SRC) -r $(GIZMO_HG_COMMIT) $@

spcool_tables:
	curl http://www.tapir.caltech.edu/~phopkins/public/spcool_tables.tgz | tar xz

TREECOOL: | gizmo_hg
	ln -s gizmo_hg/cooling/TREECOOL $@

.PHONY: recompile
recompile:
	cd gizmo_hg && make clean
	rm GIZMO
	make GIZMO
