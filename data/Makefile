.PHONY: all

all: spcool_tables

%: %.tgz
	tar -xzf $<

spcool_tables.tgz:
	curl -O http://www.tapir.caltech.edu/~phopkins/public/spcool_tables.tgz
