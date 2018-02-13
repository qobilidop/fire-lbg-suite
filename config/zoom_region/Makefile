.PHONY: sync

sync:
	rsync -avz --update bridges:~/scratch/z2f2-run/config/zoom_region/* .

z2h350_ref13_rad%.txt:
	cd ../../run/ref13_dm/ && gen_zoom_region --rad $*
	mv ../../run/ref13_dm/zoom_region.txt $@

z2h350.txt:
	scp ranch:/home2/01708/cfaucher/SCRATCH_stamp/dm_512_MUSIC_ex_halo350_Jan9_2014/dm_512_MUSIC_ex_zoom_coords_halo350.dat $@
