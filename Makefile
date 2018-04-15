REMOTE = bridges:~/project/z2h-fire2

.PHONY: deploy install

capture:
	rsync -aPvz --update $(REMOTE)/data/benchmark data/
	rsync -aPvz --update $(REMOTE)/data/contamination data/
	rsync -aPvz --update $(REMOTE)/data/zoom_region data/

deploy:
	rsync -avz --delete-after --filter=':- .gitignore' . $(REMOTE)/

install:
	cd conda && make

uninstall:
	cd conda && make clean
