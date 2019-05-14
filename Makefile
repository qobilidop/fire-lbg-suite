.PHONY: install
install: | env
	env/bin/pip install -e .

env: environment.yml
	conda env update -f $< -p $@
