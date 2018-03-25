.PHONY: sync

sync:
	rsync -avz --update $(REPO_ROOT_BRIDGES)/benchmark/ref12/results.csv .

results.csv:
	gen_bench_results
