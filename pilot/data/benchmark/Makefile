.PHONY: all

all: ref11.csv ref12.csv ref13.csv

%.csv: ../../lab/benchmark/%
	cd $< && gen_bench_results.py
	mv $</results.csv $@
