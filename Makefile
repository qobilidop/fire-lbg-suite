.PHONY: help
help:
	cat Makefile


# Environment management
.PHONY: init purge

init:
	./env/init.sh
	cd data && make

purge:
	rm -rf .conda .local env/repo


# Data synchronization
.PHONY: deploy-bridges deploy-tscc

sync = rsync -Kamrvz --update
sync-deploy = $(sync) --filter ':- .gitignore' --exclude '.git'
project-name = fire2-lbg
remote-bridges = bridges:~/project/$(project-name)
remote-tscc = tscc:~/project/$(project-name)

deploy-bridges:
	$(sync-deploy) . $(remote-bridges)

deploy-tscc:
	$(sync-deploy) . $(remote-tscc)
