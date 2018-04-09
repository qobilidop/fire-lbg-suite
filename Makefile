REMOTE = bridges:~/scratch/z2h-fire2

.PHONY: deploy install

capture:
	rsync -aPvz --update $(REMOTE)/data/benchmark/ data/benchmark/
	rsync -aPvz --update $(REMOTE)/data/zoom_region/ data/zoom_region/

deploy:
	rsync -avz --delete-after --filter=':- .gitignore' . $(REMOTE)/

install:
	./src/install.sh
