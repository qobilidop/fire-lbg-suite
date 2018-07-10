#!/usr/bin/env bash

set -e

mkdir -p "$LOCAL_DIR/opt"
cd "$LOCAL_DIR/opt"
curl http://popia.ft.uam.es/AHF/files/ahf-v1.0-094.tgz | tar xz
cd ahf-v1.0-094
patch Makefile "$PROJECT_DIR/code/extern/ahf/Makefile.patch"

export CC="$LOCAL_CC -std=c99 $LOCAL_OPT_OMP"
export FC="$LOCAL_FC"
export OPTIMIZE="-O2"
export CCFLAGS=
export LNFLAGS="-Wl,-rpath,$LOCAL_DIR/lib"
export DEFINEFLAGS=
export MAKE="make"

# Compile AHF-dmo for dark matter only simulations
make clean
export DEFINEFLAGS="-DMULTIMASS -DWITH_OPENMP"
export AHF_BIN="AHF-dmo"
make AHF

# Compile AHF for hydro simulations
make clean
export DEFINEFLAGS="-DMULTIMASS -DGAS_PARTICLES -DREFINE_BARYONIC_MASS -DWITH_OPENMP"
export AHF_BIN="AHF"
make AHF

mv bin/* $LOCAL_DIR/bin/
