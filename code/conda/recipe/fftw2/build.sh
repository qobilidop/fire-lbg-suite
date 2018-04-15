#!/usr/bin/env bash

# Installing FFTW in both single and double precision
# See http://www.fftw.org/fftw2_doc/fftw_6.html#SEC69

export CC="$MY_CC"
export MPICC="$MY_MPICC"
configure="./configure --prefix=$PREFIX --enable-mpi --enable-type-prefix"

$configure
make -j$CPU_COUNT
make install
make clean
$configure --enable-float
make -j$CPU_COUNT
make install
