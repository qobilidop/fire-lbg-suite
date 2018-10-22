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
.PHONY: deploy capture

sync = rsync -Kamrvz --update
remote = bridges:~/project/fire2-lbg

deploy:
	$(sync) --filter ':- .gitignore' --exclude '.git' . $(remote)

capture:
	$(sync) --delete $(remote)/result result
