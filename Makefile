.PHONY: help
help:
	cat Makefile

.PHONY: init
init:
	./env/init.sh

.PHONY: purge
purge:
	rm -rf .local
