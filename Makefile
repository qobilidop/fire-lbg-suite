.PHONY: deploy install

deploy:
	rsync -avz --delete-after --filter=':- .gitignore' . bridges:~/scratch/z2f2-run

install:
	conda env create -f install/environment.yml --force
	./install/fftw2.sh
