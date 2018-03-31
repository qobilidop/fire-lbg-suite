# Initialize Bridges environment

# Load modules
module purge
module load psc_path slurm/17.02.5
module load intel/17.4 mpi/intel_mpi
module load fftw3/3.3.4

# Compiler settings
export MY_CC=icc
export MY_CXX=icpc
export MY_FC=ifort
export MY_MPICC=mpiicc
export MY_MPICXX=mpiicpc
export MY_MPIFC=mpiifort
export MY_OPT_MPI="-mt_mpi"
export MY_OPT_OMP="-qopenmp"

# System packages
export MY_FFTW3_INC="-I$FFTW3_INCLUDE"
export MY_FFTW3_LIB="-L$FFTW3_LIB"
export MY_GSL_INC="-I/usr/include/gsl"
export MY_GSL_LIB="-L/lib64"
export MY_MKL_INC="-I$MKLROOT/include"
export MY_MKL_LIB="-L$MKLROOT/lib"

source init-general.sh
