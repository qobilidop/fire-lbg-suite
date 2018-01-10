.PHONY: all

all: output_times.txt spcool_tables

output_times.txt:
	scp ranch:/home2/01708/cfaucher/SCRATCH_stamp/dm_512_MUSIC_ex/output_times.txt $@

%: %.tgz
	tar -xzf $<

spcool_tables.tgz:
	curl -O http://www.tapir.caltech.edu/~phopkins/public/spcool_tables.tgz
