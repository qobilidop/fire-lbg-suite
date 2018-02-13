.PHONY: sync

sync:
	rsync -avz --update $(REPO_ROOT_BRIDGES)/benchmark/ref13_dm/results.csv .

results.csv:
	gen_bench_results
