.PHONY: download sync

download: z2h350.txt z2h600.txt

z2h%.txt:
	scp ranch:/home2/01708/cfaucher/SCRATCH_stamp/dm_512_MUSIC_ex_halo$*_Jan9_2014/dm_512_MUSIC_ex_zoom_coords_halo$*.dat $@

sync:
	rsync -avz --update $(REPO_ROOT_BRIDGES)/config/zoom_region/* .

z2h350_ref13_rad%.txt:
	cd ../../run/ref13_dm/ && gen_zoom_region --rad $*
	mv ../../run/ref13_dm/zoom_region.txt $@
