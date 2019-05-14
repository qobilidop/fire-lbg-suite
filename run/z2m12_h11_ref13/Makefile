GIZMO_HG_SRC = ssh://hg@bitbucket.org/phopkins/gizmo
GIZMO_HG_COMMIT = 76dbfab6c0fbef056b713410e5eb73f8c1b00205

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