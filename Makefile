.PHONY: deploy install

deploy:
	rsync -avz --delete-after --filter=':- .gitignore' . $(REPO_ROOT_BRIDGES)

install:
	conda env create -f install/environment.yml --force
	./install/fftw2.sh
