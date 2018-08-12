.PHONY: help
help:
	cat Makefile

.PHONY: init
init:
	./env/init.sh
	cd data && make

.PHONY: purge
# Purge local env
purge:
	rm -rf .conda .local

.PHONY: deploy
deploy:
	deploy.sh bridges:~/project/fire2-lbg
