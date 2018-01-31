.PHONY: data src compile submit


data: output_times.txt

output_times.txt:
	cp $(REPO_ROOT)/data/{{ data.output_times }} $@
{%- if general.zoom %}

data: ic/zoom_region.txt

ic/zoom_region.txt:
	cp $(REPO_ROOT)/data/{{ data.zoom_region }} $@
{%- endif %}
{%- if general.baryon %}

data: spcool_tables TREECOOL

spcool_tables:
	curl http://www.tapir.caltech.edu/\~phopkins/public/spcool_tables.tgz | tar -xz

TREECOOL:
	ln -s gizmo/cooling/$@ .
{%- endif %}


src: | gizmo ic/music

gizmo:
	hg clone -r {{ gizmo.commit }} {{ gizmo.source }} $@

ic/music:
	hg clone -r {{ music.commit }} {{ music.source }} $@


compile: gizmo/GIZMO ic/music/MUSIC

gizmo/GIZMO: | gizmo
	cp gizmo_Config.sh gizmo/Config.sh
	cp gizmo_Makefile.systype gizmo/Makefile.systype
	cd gizmo && make

ic/music/MUSIC: | ic/music
	cp ic/music_Makefile ic/music/Makefile
	cd ic/music && make


submit: data compile
	RUN={{ name }} ./submit.sh
