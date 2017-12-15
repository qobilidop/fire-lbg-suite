include Makefile.run

.PHONY: config compile submit clean destroy



config: gizmo_Config.sh gizmo_params.txt ic/music.conf ic/zoom_region.txt

gizmo_Config.sh: $(REPO_ROOT)/config/gizmo/$(GIZMO_CONFIG)
	cp $< $@

gizmo_params.txt: $(REPO_ROOT)/config/gizmo/$(GIZMO_PARAMS)
	cp $< $@

ic/music.conf: $(REPO_ROOT)/config/music/$(MUSIC_CONFIG)
	cp $< $@

ic/zoom_region.txt: $(REPO_ROOT)/config/music/$(MUSIC_ZOOM_REGION)
	cp $< $@



compile: gizmo/GIZMO ic/music/MUSIC config

gizmo/GIZMO: gizmo/Config.sh gizmo/Makefile.systype
	cd gizmo && make

gizmo/%: gizmo_% | gizmo
	cp $< $@

gizmo:
	hg clone https://bitbucket.org/phopkins/gizmo

ic/music/MUSIC: ic/music/Makefile
	cd ic/music && make

ic/music/%: ic/music_% | ic/music
	cp $< $@

ic/music:
	cd ic && hg clone https://bitbucket.org/ohahn/music



submit: compile
	RUN=$(RUN) ./submit.sh



clean:
	cd gizmo && make clean
	cd ic/music && make clean



destroy:
	$(shell find . ! -name 'Makefile.run' -type f -exec rm -f {} +)
	$(shell find . -type d -exec rm -rf {} +)
