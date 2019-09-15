GIZMO_GIT_SRC = git@bitbucket.org:phopkins/gizmo.git
# commit message: Merged default into FIRE_FrozenBranch_Nov13_2015
# commit date: 2018-06-17
# original hg commit: 76dbfab6c0fbef056b713410e5eb73f8c1b00205
GIZMO_GIT_COMMIT = 46c30dab9703f13fdbfd410e3ea4941e97860aa9

.PHONY: init
init: GIZMO spcool_tables TREECOOL

GIZMO: gizmo_config.sh | gizmo_repo
	cp gizmo_config.sh gizmo_repo/Config.sh
	spack diy -d gizmo_repo -n gizmo@local && eval `spack env deactivate --sh` && spack uninstall -y gizmo@local
	ln -s gizmo_repo/GIZMO $@

gizmo_repo:
	git clone $(GIZMO_GIT_SRC) $@
	cd $(GIZMO_GIT_SRC) && git checkout $(GIZMO_GIT_COMMIT)

spcool_tables:
	curl http://www.tapir.caltech.edu/~phopkins/public/spcool_tables.tgz | tar xz

TREECOOL: | gizmo_repo
	ln -s gizmo_repo/cooling/TREECOOL $@

.PHONY: recompile
recompile:
	cd gizmo_repo && make clean
	rm GIZMO
	make GIZMO
