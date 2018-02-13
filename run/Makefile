.PHONY: sync main_halo

sync:
	rsync -avz --update bridges:~/scratch/z2f2-run/run/*.csv .

main_halo: ref13_dm.main_halo.csv ref13_rad4_dm.main_halo.csv

%.main_halo.csv: %/main_halo.csv
	cp $< $@

%/main_halo.csv:
	cd $* && gen_halo_stat
