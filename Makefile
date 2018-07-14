.PHONY: help
help:
	cat Makefile

.PHONY: init
# Initialize local env for the first time:
# $ source env/activate
# $ source env/<LOCAL_ENV>/activate
# $ make init
# Activate local env afterwords:
# $ source env/activate
init:
	./env/init.sh

.PHONY: purge
# Purge local env
purge:
	rm -rf .local
