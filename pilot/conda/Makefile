.PHONY: all clean

all: channel env pkg/fftw2

channel:
	# Build conda channel
	# https://conda.io/docs/commands/build/conda-build.html
	for recipe in recipe/* ; do \
		echo Building $$recipe ; \
		conda build $$recipe --output-folder $@ -c conda-forge -c ./$@ ; \
		echo ; \
	done

env: environment.yml channel
	conda env create -f $< -p $@ -q

pkg/%: channel
	conda create -y -c ./$< -p $@ $*

clean:
	rm -rf channel env pkg
