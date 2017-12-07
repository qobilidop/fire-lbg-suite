#!/bin/bash            # this line only there to enable syntax highlighting in this file


####################################################################################################
# --------------------------------------- Multi-Threading (parallelization) options
####################################################################################################
OPENMP=2                       # Masterswitch for explicit OpenMP implementation
#PTHREADS_NUM_THREADS=2        # custom PTHREADs implementation (don't enable with OPENMP)
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
#OUTPUT_ADDITIONAL_RUNINFO      # enables extended simulation output data (can slow down machines significantly in massively-parallel runs)
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
PMGRID=512                     # COSMO enable: resolution of particle-mesh grid
PM_PLACEHIGHRESREGION=1+2+16   # COSMO enable: particle types to place high-res PMGRID around
PM_HIRES_REGION_CLIPPING=2000  # for stability: clips particles that escape the hires region in zoom/isolated sims
#PM_HIRES_REGION_CLIPDM         # split low-res DM particles that enter high-res region (completely surrounded by high-res)
MULTIPLEDOMAINS=16             # Multi-Domain option for the top-tree level: iso=16,COSMO=64-128
                               # total number of domains = MULTIPLEDOMAINS * MPI_NUMBER
## -----------------------------------------------------------------------------------------------------
# ---------------------------------------- Adaptive Grav. Softening (including Lagrangian conservation terms!)
ADAPTIVE_GRAVSOFT_FORGAS       # allows variable softening length (=Hsml) for gas particles
#ADAPTIVE_GRAVSOFT_FORALL=1000  # enable adaptive gravitational softening lengths for all particle types
                                # (ADAPTIVE_GRAVSOFT_FORGAS should be disabled). the softening is set to the distance
                                # enclosing a neighbor number set in the parameter file. baryons search for other baryons,
                                # dm for dm, sidm for sidm, etc. If set to numerical value, the maximum softening is this times All.ForceSoftening[for appropriate particle type]
## -----------------------------------------------------------------------------------------------------
#NOGRAVITY                      # turn off self-gravity (compatible with analytic_gravity)
#GRAVITY_NOT_PERIODIC           # self-gravity is not periodic, even though the rest of the box is periodic
## -----------------------------------------------------------------------------------------------------
#ANALYTIC_GRAVITY               # Specific analytic gravitational force to use instead of/with self-gravity. If set to a numerical value
                                #  > 0 (e.g. =1), then BH_CALC_DISTANCES will be enabled, and it will use the nearest BH particle as the center for analytic gravity computations
                                #  (edit "gravity/analytic_gravity.h" to actually assign the analytic gravitational forces)
##-----------------------------------------------------------------------------------------------------
#--------------------------------------- Self-Interacting DM (Rocha et al. 2012)
#-------------------------------- use of these routines requires explicit pre-approval by developers
#--------------------------------    P. Hopkins & J. Bullock or M. Boylan-Kolchin (acting for M. Rocha)
#SIDM=2                         # Self-interacting particle types (specify the particle types which are self-interacting DM
                                # with a bit mask, as for PM_PLACEHIGHRESREGION above (see description)
                                # (previous "DMDISK_INTERACTIONS" is identical to setting SIDM=2+4)
####################################################################################################


####################################################################################################
# --------------------------------------- Hydro solver method
####################################################################################################
HYDRO_MESHLESS_FINITE_MASS     # Lagrangian (constant-mass) finite-volume Godunov method
PROTECT_FROZEN_FIRE            # use original hydro limiter, using volume-averaging, for particles with way different kernel sizes
#HYDRO_MESHLESS_FINITE_VOLUME   # Moving (quasi-Lagrangian) finite-volume Godunov method
## -----------------------------------------------------------------------------------------------------
# --------------------------------------- SPH methods:
#SPHEQ_DENSITY_INDEPENDENT_SPH  # force SPH to use the 'pressure-sph' formulation ("modern" SPH)
#SPHEQ_TRADITIONAL_SPH          # force SPH to use the 'density-sph' (GADGET-2 & GASOLINE SPH)
# --------------------------------------- SPH artificial diffusion options (use with SPH; not relevant for Godunov/Mesh modes)
#SPHAV_DISABLE_CD10_ARTVISC     # Disable Cullen & Dehnen 2010 'inviscid sph' (viscosity suppression outside shocks); just use Balsara switch
#SPHAV_DISABLE_PM_CONDUCTIVITY  # Disable mixing entropy (J.Read's improved Price-Monaghan conductivity with Cullen-Dehnen switches)
## -----------------------------------------------------------------------------------------------------
# --------------------------------------- Kernel Options
#KERNEL_FUNCTION=3              # Choose the kernel function (2=quadratic peak, 3=cubic spline [default], 4=quartic spline, 5=quintic spline, 6=Wendland C2, 7=Wendland C4, 8=2-part quadratic)
####################################################################################################


####################################################################################################
# --------------------------------------- Additional Fluid Physics
####################################################################################################
##-----------------------------------------------------------------------------------------------------
#---------------------------------------- Gas Equations-of-State
#EOS_GAMMA=(5.0/3.0)            # Polytropic Index of Gas (for an ideal gas law): if not set and no other (more complex) EOS set, defaults to GAMMA=5/3
#EOS_HELMHOLTZ                  # Use Timmes & Swesty 2000 EOS (for e.g. stellar or degenerate equations of state; developed by D. Radice; use requires explicit pre-approval)
## -----------------------------------------------------------------------------------------------------
# --------------------------------- Magneto-Hydrodynamics
# ---------------------------------  these modules are public, but if used, the user should also cite the MHD-specific GIZMO methods paper
# ---------------------------------  (Hopkins 2015: 'Accurate, Meshless Methods for Magneto-Hydrodynamics') as well as the standard GIZMO paper
#MAGNETIC                       # master switch for MHD, regardless of which Hydro solver is used
#B_SET_IN_PARAMS                # set initial fields (Bx,By,Bz) in parameter file
#MHD_NON_IDEAL                  # enable non-ideal MHD terms: Ohmic resistivity, Hall effect, and ambipolar diffusion (solved explicitly)
#CONSTRAINED_GRADIENT_MHD=1     # use CG method (in addition to cleaning, optional!) to maintain low divB: set this value to control how aggressive the div-reduction is:
                                # 0=minimal (safest), 1=intermediate (recommended), 2=aggressive (less stable), 3+=very aggressive (less stable+more expensive)
##-----------------------------------------------------------------------------------------------------
##-----------------------------------------------------------------------------------------------------
#--------------------------------------- Conduction
#CONDUCTION                     # Thermal conduction solved *explicitly*: isotropic if MAGNETIC off, otherwise anisotropic
#CONDUCTION_SPITZER             # Spitzer conductivity accounting for saturation: otherwise conduction coefficient is constant
##-----------------------------------------------------------------------------------------------------
##-----------------------------------------------------------------------------------------------------
#--------------------------------------- Viscosity
#VISCOSITY                      # Navier-stokes equations solved *explicitly*: isotropic coefficients if MAGNETIC off, otherwise anisotropic
#VISCOSITY_BRAGINSKII           # Braginskii viscosity tensor for ideal MHD
##-----------------------------------------------------------------------------------------------------
##-----------------------------------------------------------------------------------------------------
#--------------------------------------- Radiative Cooling physics (mostly geared towards galactic/extragalactic cooling)
#--------------------------- These modules were originally developed for a combination of -proprietary- physics modules. they can only be used with
#--------------------------- permission from the authors. email P. Hopkins to obtain the relevant permissions for the cooling routines of interest.
COOLING                        # enables radiative cooling and heating: if GALSF, also external UV background read from file "TREECOOL"
COOL_LOW_TEMPERATURES          # allow fine-structure and molecular cooling to ~10 K; account for optical thickness and line-trapping effects with proper opacities
COOL_METAL_LINES_BY_SPECIES    # use full multi-species-dependent cooling tables ( https://dl.dropbox.com/u/16659252/spcool_tables.tgz )
#GRACKLE                        # enable GRACKLE: cooling+chemistry package (requires COOLING above; https://grackle.readthedocs.org/en/latest )
#GRACKLE_CHEMISTRY=1            # choose GRACKLE cooling chemistry: (0)=tabular, (1)=Atomic, (2)=(1)+H2+H2I+H2II, (3)=(2)+DI+DII+HD
##-----------------------------------------------------------------------------------------------------
##-----------------------------------------------------------------------------------------------------
#--------------------------------------- Smagorinsky Turbulent Eddy Diffusion Model
#---------------------------------------- (this is developed by P. Hopkins as part of the FIRE package: the same FIRE authorship & approval policies apply, see below)
TURB_DIFF_METALS               # turbulent diffusion of metals (passive scalars)
#TURB_DIFF_ENERGY               # turbulent diffusion of internal energy (conduction with effective turbulent coefficients)
#TURB_DIFF_VELOCITY             # turbulent diffusion of momentum (viscosity with effective turbulent coefficients)
####################################################################################################


####################################################################################################
#------------------ Galaxy formation / Star formation / Supermassive BH Models (with feedback)
####################################################################################################
#---- basic/master switches ---- #
#SINGLE_STAR_FORMATION          # master switch for single star formation model: sink particles representing -individual- stars
GALSF                          # master switch for galactic star formation model: enables SF, stellar ages, metals, generations, etc.
METALS                         # enable metallicities (with multiple species optional) for gas and stars
##GALSF_GENERATIONS=1           # the number of stars a gas particle may spawn (defaults to 1, set otherwise)
##-----------------------------------------------------------------------------------------------------------------------------
#----- old sub-grid models (for large-volume simulations) ---- #
#--------- these are all ultimately variations of the Springel & Hernquist 2005 sub-grid models for the ISM, star formation,
#--------- and stellar winds. their use follows the GADGET-3 use policies. If you are not sure whether you have permission to use them,
#--------- you should contact those authors (Lars Hernquist & Volker Springel)
#------------------------------------------------------------------------------------------------------------------------------
#GALSF_EFFECTIVE_EQS            # 'effective equation of state' model for the ISM and star formation
#GALSF_SUBGRID_WINDS            # sub-grid winds ('kicks' as in Oppenheimer+Dave,Springel+Hernquist,Boothe+Schaye,etc)
#GALSF_SUBGRID_VARIABLEVELOCITY # winds with velocity scaling based on halo properties (Oppenheimer+Dave); req.GALSF_SUBGRID_WINDS
#GALSF_SUBGRID_DMDISPERSION     # wind velocity scaling based on MV 13 paper, as used in Illustris. req.GALSF_SUBGRID_WINDS
#GALSF_WINDS_ISOTROPIC          # forces winds to have a random orientation (works with both subgrid+explicit winds)
#GALSF_WINDS_POLAR              # forces winds to have polar orientation (works for sub-grid winds)
#GALSF_TURNOFF_COOLING_WINDS    # turn off cooling for SNe-heated particles (as Stinson+ GASOLINE model; requires GALSF_FB_SNE_HEATING; use by permission of developer P. Hopkins)
#GALSF_GASOLINE_RADHEATING      # heat gas with luminosity from young stars (as Stinson+ 2013 GASOLINE model; requires GALSF_FB_SNE_HEATING; use by permission of developer P. Hopkins)
##-----------------------------------------------------------------------------------------------------
##-----------------------------------------------------------------------------------------------------
#------ PFH physical models for star formation and feedback: these are the FIRE simulation modules (Hopkins et al. 2014) ------ ##
#--------- their use follows the FIRE authorship policy. Any new project using these physics must first be agreed to by all of the
#--------- core development team of the FIRE simulations: P. Hopkins, E. Quataert, D. Keres, C.A. Faucher-Giguere.
#--------- Papers using these modules must offer co-authorship to the members of the FIRE development team.
##-----------------------------------------------------------------------------------------------------
#FIRE_PHYSICS_DEFAULTS           # enable default set of FIRE physics packages (see details below)
#---- star formation law ---- #
GALSF_SFR_MOLECULAR_CRITERION    # estimates molecular fraction in SF-ing gas, only SF from that is allowed
GALSF_SFR_VIRIAL_SF_CRITERION=0  # only allow star formation in virialized sub-regions (alpha<1) (0/no value='default'; 1=0+Jeans criterion; 2=1+'strict' (zero sf if not bound))
#GALSF_SFR_IMF_VARIATION          # determines the stellar IMF for each particle from the Guszejnov/Hopkins/Hennebelle/Chabrier/Padoan theory
#GALSF_SFR_IMF_SAMPLING           # discretely sample the IMF: simplified model with quantized number of massive stars
#----- physical stellar feedback mechanisms ---- #
GALSF_FB_GASRETURN               # Paul Torrey's addition for stochastic gas return (modified for continuous return)
GALSF_FB_HII_HEATING             # gas within HII regions around young stars is photo-heated to 10^4 K
GALSF_FB_SNE_HEATING=1           # time-dependent explosions from SNe (I & II) in shockwave radii around stars (values: 0=force-gridded in xyz (WRONG-for testing only!); 1=tensor-symmetrized (momentum-conserving; USE ME); 2=no tensor re-normalization [non-conservative!]
GALSF_FB_RPROCESS_ENRICHMENT=4   # tracks a set of 'dummy' species from neutron-star mergers (set to number: 4=extended model)
GALSF_FB_RT_PHOTONMOMENTUM       # continuous acceleration from starlight (uses luminosity tree)
GALSF_FB_LOCAL_UV_HEATING        # use local estimate of spectral information for photoionization and photoelectric heating
GALSF_FB_RPWIND_LOCAL            # turn on local radiation pressure coupling to gas
####################################################################################################


####################################################################################################
# -------------------------------------------- De-Bugging & special (usually test-problem only) behaviors
####################################################################################################
#DEVELOPER_MODE                 # allows you to modify various numerical parameters (courant factor, etc) at run-time
#EOS_ENFORCE_ADIABAT=(1.0)      # if set, this forces gas to lie -exactly- along the adiabat P=EOS_ENFORCE_ADIABAT*(rho^GAMMA)
#AGGRESSIVE_SLOPE_LIMITERS      # use the original GIZMO paper (more aggressive) slope-limiters. more accurate for smooth problems, but
                                # these can introduce numerical instability in problems with poorly-resolved large noise or density contrasts (e.g. multi-phase, self-gravitating flows)
#ENERGY_ENTROPY_SWITCH_IS_ACTIVE # enable energy-entropy switch as described in GIZMO methods paper. This can greatly improve performance on some problems where the
                                # the flow is very cold and highly super-sonic. it can cause problems in multi-phase flows with strong cooling, though, and is not compatible with non-barytropic equations of state
#TEST_FOR_IDUNIQUENESS          # explicitly check if particles have unique id numbers (only use for special behaviors)
#LONGIDS                        # use long ints for IDs (needed for super-large simulations)
#ASSIGN_NEW_IDS                 # assign IDs on startup instead of reading from ICs
#NO_CHILD_IDS_IN_ICS            # IC file does not have child IDs: do not read them (used for compatibility with snapshot restarts from old versions of the code)
#READ_HSML                      # reads hsml from IC file
#PREVENT_PARTICLE_MERGE_SPLIT   # don't allow gas particle splitting/merging operations
#COOLING_OPERATOR_SPLIT         # do the hydro heating/cooling in operator-split fashion from chemical/radiative. slightly more accurate when tcool >> tdyn, but much noisier when tcool << tdyn
#PARTICLE_EXCISION              # enable dynamical excision (remove particles within some radius)
#MERGESPLIT_HARDCODE_MAX_MASS=(1.49e-6)   # manually set maximum mass for particle merge-split operations (in code units): useful for snapshot restarts and other special circumstances. this is in *code unit*, so for a given physical mass, input: mass * h / 1e10
#MERGESPLIT_HARDCODE_MIN_MASS=(2.48e-7)   # manually set minimum mass for particle merge-split operations (in code units): useful for snapshot restarts and other special circumstances. this is in *code unit*, so for a given physical mass, input: mass * h / 1e10

#USE_MPI_IN_PLACE               # MPI debugging: makes AllGatherV compatible with MPI_IN_PLACE definitions in some MPI libraries
#NO_ISEND_IRECV_IN_DOMAIN       # MPI debugging: slower, but fixes memory errors during exchange in the domain decomposition (ANY RUN with >2e9 particles MUST SET THIS OR FAIL!)
#FIX_PATHSCALE_MPI_STATUS_IGNORE_BUG # MPI debugging
#MPISENDRECV_SIZELIMIT=100      # MPI debugging
#MPISENDRECV_CHECKSUM           # MPI debugging
#DONOTUSENODELIST               # MPI debugging
#NOTYPEPREFIX_FFTW              # FFTW debugging (fftw-header/libraries accessed without type prefix, adopting whatever was
                                #   chosen as default at compile of fftw). Otherwise, the type prefix 'd' for double is used.
#DOUBLEPRECISION_FFTW           # FFTW in double precision to match libraries
#DEBUG                          # enables core-dumps and FPU exceptions
STOP_WHEN_BELOW_MINTIMESTEP    # forces code to quit when stepsize wants to go below MinSizeTimestep specified in the parameterfile
#SEPARATE_STELLARDOMAINDECOMP   # separate stars (ptype=4) and other non-gas particles in domain decomposition (may help load-balancing)
#DISABLE_SPH_PARTICLE_WAKEUP    # don't let gas particles move to lower timesteps based on neighbor activity (use for debugging)
#EVALPOTENTIAL                  # computes gravitational potential
#MHD_ALTERNATIVE_LEAPFROG_SCHEME # use alternative leapfrog where magnetic fields are treated like potential/positions (per Federico Stasyszyn's suggestion): still testing
#FREEZE_HYDRO                   # zeros all fluxes from RP and doesn't let particles move (for testing additional physics layers)
#SUPER_TIMESTEP_DIFFUSION       # use super-timestepping to accelerate integration of diffusion operators [for testing or if there are stability concerns]
#ALLOW_IMBALANCED_GASPARTICLELOAD # increases All.MaxPartSph to All.MaxPart: can allow better load-balancing in some cases, but uses more memory. But use me if you run into errors where it can't fit the domain (where you would increase PartAllocFac, but can't for some reason)
####################################################################################################
