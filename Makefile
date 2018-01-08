.PHONY: upload install run

upload:
	rsync -avz --filter=':- .gitignore' . bridges:~/scratch/z2h-fire2-test

prepare_bridges:
	./script/install_fftw2.sh
