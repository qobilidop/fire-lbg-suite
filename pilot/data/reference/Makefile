.PHONY: all destroy

all: dm_512_MUSIC_ex_halo350_Jan9_2014 m12i_res57000 m12i_res7100 m12i_res7100_dm

dm_512_MUSIC_ex_halo350_Jan9_2014:
	mkdir -p $@
	rsync -amvz --delete --include='*/' \
	--include='gadget-p/Config.sh' \
	--include='ics_dm_512_MUSIC_ex_halo350_Dec12_2013_lean_2LPT.conf' \
	--include='zoom_cafg.txt' \
	--exclude='*' \
	ranch:/home2/01708/cfaucher/SCRATCH_stamp/$@/ $@/

m12i_res57000 m12i_res7100:
	mkdir -p $@
	rsync -amvz --delete --include='*/' \
	--include='initial_condition/ic_agora_m12i.conf' \
	--include='gizmo_config.sh' \
	--include='gizmo_parameters.txt' \
	--exclude='*' \
	stampede2:/scratch/projects/xsede/GalaxiesOnFIRE/metal_diffusion/$@/ $@/

m12i_res7100_dm:
	mkdir -p $@
	rsync -amvz --delete --include='*/' \
	--include='initial_condition/ic_agora_m12i.conf' \
	--include='gizmo_config.sh' \
	--include='gizmo_parameters.txt' \
	--exclude='*' \
	stampede2:/scratch/projects/xsede/GalaxiesOnFIRE/dm_only/$@/ $@/

refresh:
	rm -rf */
	make
