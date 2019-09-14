#!/usr/bin/env bash

export CC="$MY_CC -std=c99 $MY_OPT_OMP"
export FC="$MY_FC"
export OPTIMIZE=-O2
export CCFLAGS=
export LNFLAGS=
export DEFINEFLAGS_DEFAULT="-DWITH_OPENMP"
export MAKE="make -j$CPU_COUNT"

export DEFINEFLAGS="-DMULTIMASS $DEFINEFLAGS_DEFAULT"
export AHF_BIN="AHF_dm"
make AHF
make clean
export DEFINEFLAGS="-DMULTIMASS -DGAS_PARTICLES -DREFINE_BARYONIC_MASS $DEFINEFLAGS_DEFAULT"
export AHF_BIN="AHF"
make AHF

mv bin/* $PREFIX/bin/