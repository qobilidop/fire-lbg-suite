include Makefile.run

.PHONY: prepare init compile submit clean destroy

prepare: bootstrap init compile

init: gizmo ic/music
	cp $(REPO_ROOT)/config/gizmo/$(GIZMO_CONFIG) gizmo_config.sh
	cp $(REPO_ROOT)/config/gizmo/$(GIZMO_PARAMS) gizmo_params.txt
	cp $(REPO_ROOT)/config/music/$(MUSIC_CONFIG) ic/music.conf
	cp $(REPO_ROOT)/config/music/$(MUSIC_ZOOM_REGION) ic/zoom_region.txt

gizmo:
	hg clone https://bitbucket.org/phopkins/gizmo

ic/music:
	cd ic && hg clone https://bitbucket.org/ohahn/music

compile: gizmo/GIZMO ic/music/MUSIC

gizmo/GIZMO: | gizmo
	cp gizmo_config.sh gizmo/Config.sh
	cp gizmo_Makefile.systype gizmo/Makefile.systype
	cd gizmo && make

ic/music/MUSIC: | ic/music
	cp ic/music_Makefile ic/music/Makefile
	cd ic/music && make

submit: prepare
	RUN=$(RUN) ./submit.sh

clean:
	cd gizmo && make clean
	cd ic/music && make clean

destroy:
	$(shell find . ! -name 'Makefile.run' -type f -exec rm -f {} +)
	$(shell find . -type d -exec rm -rf {} +)
