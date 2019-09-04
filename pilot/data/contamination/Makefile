TARGETS = $(shell echo z2h{350,600}_ref13{,_rad4}_dm.csv)

.PHONY: all

all: $(TARGETS)

%.csv: ../../lab/run/%
	cd $< && diag_dm_con.py
	mv $</dm_con.csv $@
