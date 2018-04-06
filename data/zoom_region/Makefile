.PHONY: download sync

download: z2h350.txt z2h600.txt

z2h%.txt:
	scp ranch:/home2/01708/cfaucher/SCRATCH_stamp/dm_512_MUSIC_ex_halo$*_Jan9_2014/dm_512_MUSIC_ex_zoom_coords_halo$*.dat $@

capture:
	rsync -avz --update bridges:~/scratch/z2h-fire2/data/zoom_region/* .

z2h350: z2h350_ref13_rad2.txt z2h350_ref13_rad3.txt z2h350_ref13_rad4.txt z2h350_ref13_rad5.txt z2h350_ref13_rad6.txt

z2h350_ref13_rad%.txt:
	cd ../../lab/run/z2h350_ref13_dm/ && gen_zoom_region.py --rad $*
	mv ../../lab/run/z2h350_ref13_dm/zoom_region.txt $@

z2h600: z2h600_ref13_rad2.txt z2h600_ref13_rad3.txt z2h600_ref13_rad4.txt z2h600_ref13_rad5.txt z2h600_ref13_rad6.txt

z2h600_ref13_rad%.txt:
	cd ../../lab/run/z2h600_ref13_dm/ && gen_zoom_region.py --rad $*
	mv ../../lab/run/z2h600_ref13_dm/zoom_region.txt $@
