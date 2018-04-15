#!/usr/bin/env bash

export CC="$RUN_CC -std=c99 $RUN_OPT_OMP"
export FC="$RUN_FC"
export OPTIMIZE=-O2
export CCFLAGS=
export LNFLAGS=
export MAKE=make

export DEFINEFLAGS='-DMULTIMASS'
export AHF_BIN='AHF_dm'
make AHF
make clean
export DEFINEFLAGS='-DMULTIMASS -DGAS_PARTICLES -DREFINE_BARYONIC_MASS'
export AHF_BIN='AHF'
make AHF

mv bin/* $PREFIX/bin/
