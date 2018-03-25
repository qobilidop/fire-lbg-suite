# Prepare Bridges for simulation runs

source activate z2f2-run

export REPO_ROOT_BRIDGES="bridges:~/scratch/z2h-fire2"
export REPO_ROOT="$PWD"
export REPO_PREFIX="$REPO_ROOT/local"
export PATH="$REPO_ROOT/script:$PATH"
export PATH="$REPO_PREFIX/bin:$PATH"

# Load modules

module purge
module load psc_path slurm/17.02.5
module load intel/17.4 mpi/intel_mpi
module load fftw3/3.3.4 hdf5/1.8.16_intel

# Compiler settings

export RUN_CC=icc
export RUN_CXX=icpc
export RUN_FC=ifort

export RUN_MPICC=mpiicc
export RUN_MPICXX=mpiicpc
export RUN_MPIFC=mpiifort

export RUN_OPT_MPI="-mt_mpi"
export RUN_OPT_OMP="-qopenmp"

# Software paths

export RUN_FFTW2_INC="$REPO_PREFIX/include"
export RUN_FFTW2_LIB="$REPO_PREFIX/lib"
export RUN_FFTW3_INC="$FFTW3_INCLUDE"
export RUN_FFTW3_LIB="$FFTW3_LIB"
export RUN_GSL_INC="/usr/include/gsl"
export RUN_GSL_LIB="/lib64"
export RUN_HDF5_INC="$HDF5_ROOT/include"
export RUN_HDF5_LIB="$HDF5_ROOT/lib"
export RUN_MKL_INC="$MKLROOT/include"
export RUN_MKL_LIB="$MKLROOT/lib"
