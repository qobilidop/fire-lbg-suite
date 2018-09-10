.PHONY: help
help:
	cat Makefile


# Environment management
.PHONY: init purge

init:
	./env/init.sh
	cd data && make

purge:
	rm -rf .conda .local


# Data synchronization
.PHONY: deploy capture

sync = rsync -Kamrvz --update
remote = bridges:~/project/fire2-lbg

deploy:
	$(sync) --filter ':- .gitignore' --exclude '.git' --delete-after . $(remote)

capture:
	$(sync) --delete $(remote)/result result
