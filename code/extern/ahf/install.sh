#!/usr/bin/env bash
set -e

# Download
mkdir -p "$LOCAL_PREFIX/opt"
cd "$LOCAL_PREFIX/opt"
curl http://popia.ft.uam.es/AHF/files/ahf-v1.0-094.tgz | tar xz

# Patch
cd ahf-v1.0-094
patch Makefile "$PROJECT_DIR/code/extern/ahf/Makefile.patch"

# Configure
export CC="$LOCAL_CC"
export FC="$LOCAL_FC"
export OPTIMIZE=
export CCFLAGS="-std=c99 $LOCAL_CFLAGS $LOCAL_OMPFLAGS"
export LNFLAGS="$LOCAL_LDFLAGS"
export DEFINEFLAGS=
export MAKE=make

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

# Finalize
mv bin/* "$LOCAL_PREFIX"/bin/
