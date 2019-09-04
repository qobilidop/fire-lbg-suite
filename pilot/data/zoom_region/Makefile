z2h350 = z2h350.txt $(shell echo z2h350_ref13_rad{2..6}.txt)
z2h600 = z2h600.txt $(shell echo z2h600_ref13_rad{2..6}.txt)

.PHONY: all download

all: $(z2h350) $(z2h600)
	@echo $(z2h350)
	@echo $(z2h600)

z2h{350,600}.txt:
	scp ranch:/home2/01708/cfaucher/SCRATCH_stamp/dm_512_MUSIC_ex_halo$*_Jan9_2014/dm_512_MUSIC_ex_zoom_coords_halo$*.dat $@

z2h350_ref13_rad%.txt: ../../lab/run/z2h350_ref13_dm
	cd $< && gen_zoom_region.py --rad $*
	mv $</zoom_region.txt $@

z2h600_ref13_rad%.txt: ../../lab/run/z2h600_ref13_dm
	cd $< && gen_zoom_region.py --rad $*
	mv $</zoom_region.txt $@
