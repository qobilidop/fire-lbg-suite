# Prepare Bridges (https://www.psc.edu/bridges) for work

# Load modules
module purge
module load psc_path slurm/17.02.5
module load intel/17.4 mpi/intel_mpi
module load fftw3/3.3.4 hdf5/1.8.16_intel

# Compiler settings
export REPO_CC=icc
export REPO_CXX=icpc
export REPO_FC=ifort
export REPO_MPICC=mpiicc
export REPO_MPICXX=mpiicpc
export REPO_MPIFC=mpiifort

# System library paths
export REPO_FFTW3_INC="$FFTW3_INCLUDE"
export REPO_FFTW3_LIB="$FFTW3_LIB"
export REPO_GSL_INC="/usr/include/gsl"
export REPO_GSL_LIB="/lib64"
export REPO_HDF5_INC="$HDF5_ROOT/include"
export REPO_HDF5_LIB="$HDF5_ROOT/lib"
export REPO_MKL_INC="$MKLROOT/include"
export REPO_MKL_LIB="$MKLROOT/lib"

# Local paths
export REPO_ROOT="$PWD"
export REPO_PREFIX="$REPO_ROOT/local"
export REPO_FFTW2_SRC="$REPO_PREFIX/src/fftw-2.1.5"
export REPO_FFTW2_INC="$REPO_PREFIX/include"
export REPO_FFTW2_LIB="$REPO_PREFIX/lib"
