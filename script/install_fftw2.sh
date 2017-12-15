#!/usr/bin/env bash

# Download source code
mkdir -p $REPO_PREFIX/src
cd $REPO_PREFIX/src
curl -O http://www.fftw.org/fftw-2.1.5.tar.gz
tar -xzf fftw-2.1.5.tar.gz
cd fftw-2.1.5

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
