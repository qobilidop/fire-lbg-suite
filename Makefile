.PHONY: deploy install

deploy:
	rsync -avz --delete-after --filter=':- .gitignore' . bridges:~/scratch/z2h-fire2/

install:
	./src/install.sh
