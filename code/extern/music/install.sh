#!/usr/bin/env bash
set -e

mkdir -p "$LOCAL_PREFIX/opt"
cd "$LOCAL_PREFIX/opt"

# Download
source=https://bitbucket.org/ohahn/music
commit=afefabeea948f0fa951c7f031e2c53ca66d06ea2
hg clone "$source" -r "$commit"

# Patch
cd music
patch < "$PROJECT_DIR/code/extern/music/Makefile.patch"

# Configure
export CC="$LOCAL_CXX"
export OPT=-Wno-unknown-pragmas
export CFLAGS="$LOCAL_CFLAGS"
export LFLAGS="-lgsl -lgslcblas $LOCAL_LDFLAGS"
export CPATHS="-I. -I"$LOCAL_FFTW3_INC" -I"$LOCAL_GSL_INC" -I"$LOCAL_HDF5_INC""
export LPATHS="-L"$LOCAL_FFTW3_LIB" -L"$LOCAL_GSL_LIB" -L"$LOCAL_HDF5_LIB""

# Compile
make -j

# Install
mv MUSIC "$LOCAL_PREFIX"/bin/
