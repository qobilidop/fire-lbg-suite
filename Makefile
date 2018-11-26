.PHONY: help
help:
	cat Makefile

.PHONY: deploy-bridges deploy-tscc

rsync-git = rsync -Kamrvz --update --filter=':- .gitignore' --exclude='.git'
project-name = fire2-lbg
remote-bridges = bridges:~/project/$(project-name)/
remote-tscc = tscc:~/project/$(project-name)/

deploy-bridges:
	$(rsync-git) ./ $(remote-bridges)

deploy-tscc:
	$(rsync-git) ./ $(remote-tscc)

capture-tscc:
	$(rsync-git) $(remote-tscc) ./
