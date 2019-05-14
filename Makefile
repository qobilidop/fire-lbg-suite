env: environment.yml
	conda env update -f $< -p $@
