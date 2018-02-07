#!/bin/bash            # this line only there to enable syntax highlighting in this file


####################################################################################################
# --------------------------------------- Multi-Threading (parallelization) options
####################################################################################################
#OPENMP=2                       # Masterswitch for explicit OpenMP implementation
#OMP_NUM_THREADS=2              # custom PTHREADs implementation (don't enable with OPENMP)
####################################################################################################


####################################################################################################
# --------------------------------------- Output/Input options
####################################################################################################
HAVE_HDF5                      # needed when HDF5 I/O support is desired
#OUTPUT_IN_DOUBLEPRECISION      # snapshot files will be written in double precision
#INPUT_IN_DOUBLEPRECISION       # input files assumed to be in double precision (otherwise float is assumed)
OUTPUT_POSITIONS_IN_DOUBLE     # input/output files in single, but positions in double (used in hires, hi-dynamic range sims when positions differ by < float accuracy)
#INPUT_POSITIONS_IN_DOUBLE      # as above, but specific to the ICs file
OUTPUTPOTENTIAL                # forces code to compute+output potentials in snapshots
#OUTPUTACCELERATION             # output physical acceleration of each particle in snapshots
#OUTPUTCHANGEOFENERGY           # outputs rate-of-change of internal energy of gas particles in snapshots
#OUTPUT_VORTICITY               # outputs the vorticity vector
#OUTPUTTIMESTEP                 # outputs timesteps for each particle
#OUTPUTCOOLRATE                 # outputs cooling rate, and conduction rate if enabled
#OUTPUTLINEOFSIGHT              # enables on-the-fly output of Ly-alpha absorption spectra
#OUTPUTLINEOFSIGHT_SPECTRUM
#OUTPUTLINEOFSIGHT_PARTICLES
#POWERSPEC_ON_OUTPUT            # compute and output power spectra (not used)
#RECOMPUTE_POTENTIAL_ON_OUTPUT  # update potential every output even it EVALPOTENTIAL is set
####################################################################################################


####################################################################################################
# --------------------------------------- Boundary Conditions & Dimensions
####################################################################################################
PERIODIC                       # Use this if periodic boundaries are needed (otherwise open boundaries are assumed)
#BND_PARTICLES                  # particles with ID=0 are forced in place (their accelerations are set =0):
                                # use for special boundary conditions where these particles represent fixed "walls"
#LONG_X=140                     # modify box dimensions (non-square periodic box): multiply X (PERIODIC and NOGRAVITY required)
#LONG_Y=1                       # modify box dimensions (non-square periodic box): multiply Y
#LONG_Z=1                       # modify box dimensions (non-square periodic box): multiply Z
#REFLECT_BND_X                  # make the x-boundary reflecting (assumes a box 0<x<1, unless PERIODIC is set)
#REFLECT_BND_Y                  # make the y-boundary reflecting (assumes a box 0<y<1, unless PERIODIC is set)
#REFLECT_BND_Z                  # make the z-boundary reflecting (assumes a box 0<z<1, unless PERIODIC is set)
#SHEARING_BOX=1                 # shearing box boundaries: 1=r-z sheet (r,z,phi coordinates), 2=r-phi sheet (r,phi,z), 3=r-phi-z box, 4=as 3, with vertical gravity
#SHEARING_BOX_Q=(3./2.)         # shearing box q=-dlnOmega/dlnr; will default to 3/2 (Keplerian) if not set
#ONEDIM                         # Switch for 1D test problems: code only follows the x-line. requires NOGRAVITY, and all y=z=0
#TWODIMS                        # Switch for 2D test problems: code only follows the xy-plane. requires NOGRAVITY, and all z=0.
####################################################################################################


####################################################################################################
## ------------------------ Gravity & Cosmological Integration Options ---------------------------------
####################################################################################################
# --------------------------------------- TreePM Options (recommended for cosmological sims)
PMGRID=1024                    # COSMO enable: resolution of particle-mesh grid
PM_PLACEHIGHRESREGION=1+2+16   # COSMO enable: particle types to place high-res PMGRID around
PM_HIRES_REGION_CLIPPING=3000  # for stability: clips particles that escape the hires region in zoom/isolated sims
#PM_HIRES_REGION_CLIPDM         # split low-res DM particles that enter high-res region (completely surrounded by high-res)
MULTIPLEDOMAINS=16             # Multi-Domain option for the top-tree level: iso=16,COSMO=64-128
                               # total number of domains = MULTIPLEDOMAINS * MPI_NUMBER
## -----------------------------------------------------------------------------------------------------
# ---------------------------------------- Adaptive Grav. Softening (including Lagrangian conservation terms!)
#ADAPTIVE_GRAVSOFT_FORGAS       # allows variable softening length (=Hsml) for gas particles
#ADAPTIVE_GRAVSOFT_FORALL=1000  # enable adaptive gravitational softening lengths for all particle types
                                # (ADAPTIVE_GRAVSOFT_FORGAS should be disabled). the softening is set to the distance
                                # enclosing a neighbor number set in the parameter file. baryons search for other baryons,
                                # dm for dm, sidm for sidm, etc. If set to numerical value, the maximum softening is this times All.ForceSoftening[for appropriate particle type]
## -----------------------------------------------------------------------------------------------------
#NOGRAVITY                      # turn off self-gravity (compatible with analytic_gravity)
#GRAVITY_NOT_PERIODIC           # self-gravity is not periodic, even though the rest of the box is periodic
## -----------------------------------------------------------------------------------------------------
#ANALYTIC_GRAVITY               # Specific analytic gravitational force to use instead of/with self-gravity
                                #  (edit these to assign specific parameters desired in "gravity/analytic_gravity.h")
##-----------------------------------------------------------------------------------------------------
#--------------------------------------- Self-Interacting DM (Rocha et al. 2012)
#-------------------------------- use of these routines requires explicit pre-approval by developers
#--------------------------------    P. Hopkins & J. Bullock or M. Boylan-Kolchin (acting for M. Rocha)
#SIDM=2                         # Self-interacting particle types (specify the particle types which are self-interacting DM
                                # with a bit mask, as for PM_PLACEHIGHRESREGION above (see description)
                                # (previous "DMDISK_INTERACTIONS" is identical to setting SIDM=2+4)
####################################################################################################
