.PHONY: help
help:
	cat Makefile

.PHONY: init
init:
	init.sh

.PHONY: chmod
chmod:
	chmod +x bin/*.sh
	chmod +x code/script/*
	chmod +x code/install/*/install.sh
	chmod +x env/*/*.sh

.PHONY: purge
purge:
	rm -rf local/ .local-env
