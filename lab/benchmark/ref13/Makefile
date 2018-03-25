.PHONY: sync

sync:
	rsync -avz --update $(REPO_ROOT_BRIDGES)/benchmark/ref13/results.csv .

results.csv:
	gen_bench_results
