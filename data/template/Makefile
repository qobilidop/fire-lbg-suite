REPO_ROOT = {{ meta.repo_root }}

.PHONY: data src compile submit

# data
data: output_times.txt

output_times.txt: $(REPO_ROOT)/{{ data.output_times }}
	cp $< $@
{%- if general.zoom %}

data: ic/zoom_region.txt

ic/zoom_region.txt: $(REPO_ROOT)/{{ data.zoom_region }}
	cp $< $@
{%- endif %}
{%- if general.baryon %}

data: spcool_tables TREECOOL

spcool_tables:
	curl http://www.tapir.caltech.edu/\~phopkins/public/spcool_tables.tgz | tar -xz

TREECOOL:
	ln -s gizmo/cooling/$@ .
{%- endif %}
{%- if gizmo.restart_from_snapshot %}

data: output/{{ gizmo.restart_from_snapshot.split('/')[-1] }}

output/{{ gizmo.restart_from_snapshot.split('/')[-1] }}: ../{{ gizmo.restart_from_snapshot }}
	mkdir -p output
	cd output && ln -s ../$< .
{%- endif %}

# src
src: | gizmo ic/music

gizmo:
	hg clone -r {{ gizmo.commit }} {{ gizmo.source }} $@

ic/music:
	hg clone -r {{ music.commit }} {{ music.source }} $@

# compile
compile: gizmo/GIZMO ic/music/MUSIC

gizmo/GIZMO: | gizmo
	cp gizmo_Config.sh gizmo/Config.sh
	cp gizmo_Makefile.systype gizmo/Makefile.systype
	cd gizmo && make -j$(SLURM_NTASKS)

ic/music/MUSIC: | ic/music
	cp ic/music_Makefile ic/music/Makefile
	cd ic/music && make -j$(SLURM_NTASKS)

# submit
submit: data compile
	bash submit.sh
