.PHONY: help
help:
	cat Makefile

.PHONY: init
# Type the following commands to initialize local env for the first time:
# $ source env/activate
# $ source env/<LOCAL_ENV>/activate
# $ make init
# Type the following commands to activate local env afterwords:
# $ source env/activate
init:
	./env/init.sh

.PHONY: purge
purge:
	rm -rf .local
