#!/usr/bin/env bash

export CC="$LOCAL_CC -std=c99 $LOCAL_OPT_OMP"
export FC="$LOCAL_FC"
export OPTIMIZE=-O2
export CCFLAGS=
export LNFLAGS=
export DEFINEFLAGS=
export MAKE="make -j$CPU_COUNT"

# Compile AHF-dmo for dark matter only simulations
export DEFINEFLAGS="-DMULTIMASS -DWITH_OPENMP"
export AHF_BIN="AHF-dmo"
make AHF

# Compile AHF for hydro simulations
make clean
export DEFINEFLAGS="-DMULTIMASS -DGAS_PARTICLES -DREFINE_BARYONIC_MASS -DWITH_OPENMP"
export AHF_BIN="AHF"
make AHF

mv bin/* $PREFIX/bin/
