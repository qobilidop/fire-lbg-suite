# Initialize Bridges environment

# Load module
module purge
module load psc_path slurm
module load intel mpi/intel_mpi
module load fftw3 hdf5

# Compiler setting
export MY_CC=icc
export MY_CXX=icpc
export MY_FC=ifort
export MY_MPICC=mpiicc
export MY_MPICXX=mpiicpc
export MY_MPIFC=mpiifort
export MY_OPT_MPI="-mt_mpi"
export MY_OPT_OMP="-qopenmp"

# System package
export MY_FFTW3_INC="-I$FFTW3_INCLUDE"
export MY_FFTW3_LIB="-L$FFTW3_LIB"
export MY_GSL_INC="-I/usr/include/gsl"
export MY_GSL_LIB="-L/lib64"
export MY_HDF5="-I$HDF5_ROOT/include"
export MY_HDF5="-L$HDF5_ROOT/lib"
export MY_MKL_INC="-I$MKLROOT/include"
export MY_MKL_LIB="-L$MKLROOT/lib"

# User package
export MY_FFTW2_INC="-I$PWD/conda/pkg/fftw2/include"
export MY_FFTW2_LIB="-I$PWD/conda/pkg/fftw2/lib"
export LIBRARY_PATH="$PWD/conda/pkg/fftw2/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="$PWD/conda/pkg/fftw2/lib:$LD_LIBRARY_PATH"

# Export PATH
export PATH="$PWD/bin:$PATH"

source activate "$PWD/conda/env"
