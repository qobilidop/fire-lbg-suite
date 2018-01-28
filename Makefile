.PHONY: upload install run

upload:
	rsync -avz --filter=':- .gitignore' . bridges:~/scratch/z2f2

prepare_bridges:
	./script/install_fftw2.sh
