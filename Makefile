.PHONY: help
help:
	cat Makefile

CONDA_ENV_NAME = fire2-lbg
CONDA_ENV_PIP = $(shell conda info --root)/envs/$(CONDA_ENV_NAME)/bin/pip

.PHONY: init
init:
	conda env create -n $(CONDA_ENV_NAME) -f lab/environment.yml
	cd lab && $(CONDA_ENV_PIP) install -e .

.PHONY: up
up:
	conda env update -n $(CONDA_ENV_NAME) -f lab/environment.yml
	cd lab && $(CONDA_ENV_PIP) install -e .
