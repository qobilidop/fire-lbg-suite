.PHONY: upload src install run

upload:
	rsync -avz --filter=':- .gitignore' . bridges:~/scratch/z2h-fire2-test

src:
	cd $(REPO_PREFIX)/src && make

install: src
	./install_fftw2.sh

run:
	cd run/z2h350_fire2 && make -f Makefile.run && make submit
