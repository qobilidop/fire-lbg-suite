.PHONY: upload install run

upload:
	rsync -avz --filter=':- .gitignore' . bridges:~/scratch/z2h-fire2-test

install:
	./script/install_fftw2.sh

run:
	cd run/z2h350_fire2 && make -f Makefile.run && make submit
