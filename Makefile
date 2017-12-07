.PHONY: upload src build run

upload:
	rsync -avz --filter=':- .gitignore' . bridges:~/scratch/z2h-fire2-test

src:
	cd src && make

build:
	cd build/fftw2 && ./build.sh
	cd build/gizmo && ./build.sh
	cd build/music && ./build.sh

run:
	cd run/z2h350_fire2 && ./run.sh
