# Conda packages
source activate $PWD/src/conda/env
export RUN_FFTW2_INC="$CONDA_PREFIX/include"
export RUN_FFTW2_LIB="$CONDA_PREFIX/lib"
export RUN_HDF5_INC="$CONDA_PREFIX/include"
export RUN_HDF5_LIB="$CONDA_PREFIX/lib"

# Export PATH
export PATH=$PWD/src/script:$PATH
