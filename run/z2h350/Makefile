RUN = z2h350
GIZMO_SOURCE = https://bitbucket.org/phopkins/gizmo
GIZMO_COMMIT = 1f8f0075624a4844e6728f53bf67ead1ff6838d7
MUSIC_SOURCE = https://bitbucket.org/ohahn/music
MUSIC_COMMIT = 12e7b54e7512e7ca5ed19875b643137c59379a20


.PHONY: data src compile submit clean destroy


data: ic/zoom_region.txt spcool_tables TREECOOL

ic/zoom_region.txt:
	scp ranch:/home2/01708/cfaucher/SCRATCH_stamp/dm_512_MUSIC_ex_halo350_Jan9_2014/dm_512_MUSIC_ex_zoom_coords_halo350.dat $@

spcool_tables:
	cd ../../data && make $@
	ln -s ../../data/$@ .

TREECOOL:
	ln -s gizmo/cooling/$@ .


src: | gizmo ic/music

gizmo:
	hg clone -r $(GIZMO_COMMIT) $(GIZMO_SOURCE) $@

ic/music:
	hg clone -r $(MUSIC_COMMIT) $(MUSIC_SOURCE) $@


compile: gizmo/GIZMO ic/music/MUSIC

gizmo/GIZMO: | gizmo
	cp gizmo_Config.sh gizmo/Config.sh
	cp gizmo_Makefile.systype gizmo/Makefile.systype
	cd gizmo && make

ic/music/MUSIC: | ic/music
	cp ic/music_Makefile ic/music/Makefile
	cd ic/music && make


submit: data compile
	RUN=$(RUN) ./submit.sh


clean:
	cd gizmo && make clean
	cd ic/music && make clean


destroy:
	rm -rf ic/music
	rm -rf gizmo
	rm -rf job
	rm -rf output
	rm spcool_tables
	rm TREECOOL
