.PHONY: help
help:
	cat Makefile

.PHONY: init
init:
	init.sh

.PHONY: purge
purge:
	rm -rf local/ .local-env
