.PHONY: install
install: conda

conda: environment.yml
	conda env create -f $< -p $@
	$@/bin/pip install -e .
