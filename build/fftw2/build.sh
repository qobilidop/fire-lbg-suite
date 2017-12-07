#!/usr/bin/env bash

cd $REPO_FFTW2_SRC

# Installing FFTW in both single and double precision
# See http://www.fftw.org/fftw2_doc/fftw_6.html#SEC69
export CC="$REPO_CC"
export MPICC="$REPO_MPICC"
configure="./configure --prefix=$REPO_PREFIX --enable-mpi --enable-type-prefix"
$configure
make
make install
make clean
$configure --enable-float
make
make install
