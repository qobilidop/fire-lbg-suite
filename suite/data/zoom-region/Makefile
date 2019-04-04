CONFIG_DIR = ../..
RUN_DIR = $(CONFIG_DIR)/../run

%-box-rad4.txt:
	prepare-region-point-file.py \
	--halo_sample $(CONFIG_DIR)/halo-sample/sample.csv \
	--halo_label $* \
	--halo_snap $(RUN_DIR)/box/output/snapdir_005/snapshot_005.0.hdf5 \
	--ic_snap $(RUN_DIR)/box/initial-condition/snapshot.0 \
	--zoom_radius 4 \
	--output $@
