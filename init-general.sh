# Conda packages
source activate $PWD/src/conda/env
CONDA_INC="-I$CONDA_PREFIX/include"
CONDA_LIB="-Wl,-rpath,$CONDA_PREFIX/lib -L$CONDA_PREFIX/lib"
export MY_FFTW2_INC=$CONDA_INC
export MY_FFTW2_LIB=$CONDA_LIB
export MY_HDF5_INC=$CONDA_INC
export MY_HDF5_LIB=$CONDA_LIB

# Export PATH
export PATH="$PWD/src/script:$PATH"
