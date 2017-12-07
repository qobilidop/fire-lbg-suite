.PHONY: all

all: fftw-2.1.5 gizmo music

fftw-2.1.5: fftw-2.1.5.tar.gz
	tar -xzf $<

fftw-2.1.5.tar.gz:
	curl -O http://www.fftw.org/$@

gizmo:
	hg clone https://bitbucket.org/phopkins/gizmo

music:
	hg clone https://bitbucket.org/ohahn/music
