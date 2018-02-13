.PHONY: sync

sync:
	rsync -avz --update bridges:~/scratch/z2f2-run/benchmark/ref12/results.csv .

results.csv:
	gen_bench_results
