#!/bin/bash            # this line only there to enable syntax highlighting in this file

####################################################################################################
#  Enable/Disable compile-time options as needed: this is where you determine how the code will act
#  From the list below, please activate/deactivate the
#       options that apply to your run. If you modify any of these options,
#       make sure that you recompile the whole code by typing "make clean; make".
#
#  Consult the User Guide before enabling any option. Some modules are proprietary -- access to them
#    must be granted separately by the code authors (just having the code does NOT grant permission).
#    Even public modules have citations which must be included if the module is used for published work,
#    these are all given in the User Guide.
#
# This file was originally part of the GADGET3 code developed by
#   Volker Springel (volker.springel@h-its.org). The code has been modified
#   substantially by Phil Hopkins (phopkins@caltech.edu) for GIZMO (to add new modules and clean
#   up the naming conventions and changed many of them to match the new GIZMO conventions)
#
####################################################################################################



####################################################################################################
# --------------------------------------- Boundary Conditions & Dimensions
####################################################################################################
BOX_PERIODIC               # Use this if periodic boundaries are needed (otherwise open boundaries are assumed)
####################################################################################################



####################################################################################################
# --------------------------------------- Hydro solver method
####################################################################################################
# --------------------------------------- Finite-volume Godunov methods (choose one, or SPH)
HYDRO_MESHLESS_FINITE_MASS     # solve hydro using the mesh-free Lagrangian (fixed-mass) finite-volume Godunov method
####################################################################################################



####################################################################################################
# --------------------------------------- Additional Fluid Physics
####################################################################################################
## ----------------------------------------------------------------------------------------------------
# -------------------------------------- Radiative Cooling physics (mostly geared towards galactic/extragalactic cooling)
# -------------------------- These modules were originally developed for a combination of proprietary physics modules. However they are now written in
# --------------------------   a form which allows them to be modular. Users are free to use the Grackle modules and standard 'COOLING' flags,
# --------------------------   provided proper credit/citations are provided to the relevant methods papers given in the Users Guide ---
# --------------------------   but all users should cite Hopkins et al. 2017 (arXiv:1702.06148), where Appendix B details the cooling physics
COOLING                        # enables radiative cooling and heating: if GALSF, also external UV background read from file "TREECOOL" (included in the cooling folder)
COOL_LOW_TEMPERATURES          # allow fine-structure and molecular cooling to ~10 K; account for optical thickness and line-trapping effects with proper opacities
COOL_METAL_LINES_BY_SPECIES    # use full multi-species-dependent cooling tables ( http://www.tapir.caltech.edu/~phopkins/public/spcool_tables.tgz, or the Bitbucket site); requires METALS on; cite Wiersma et al. 2009 (MNRAS, 393, 99) in addition to Hopkins et al. 2017 (arXiv:1702.06148)
METALS                         # enable metallicities (with multiple species optional) for gas and stars [must be included in ICs or injected via dynamical feedback; needed for some routines]
## ----------------------------------------------------------------------------------------------------
# -------------------------------------- Smagorinsky Turbulent Eddy Diffusion Model
# --------------------------------------- Users of these modules should cite Hopkins et al. 2017 (arXiv:1702.06148) and Colbrook et al. (arXiv:1610.06590)
TURB_DIFF_METALS               # turbulent diffusion of metals (passive scalars); requires METALS
####################################################################################################



####################################################################################################
## ------------------------ Gravity & Cosmological Integration Options ---------------------------------
####################################################################################################
# --------------------------------------- TreePM Options (recommended for cosmological sims)
PMGRID=512                     # COSMO enable: resolution of particle-mesh grid
PM_PLACEHIGHRESREGION=1+2+16   # COSMO enable: particle types to place high-res PMGRID around
PM_HIRES_REGION_CLIPPING=2000  # for stability: clips particles that escape the hires region in zoom/isolated sims
## -----------------------------------------------------------------------------------------------------
# ---------------------------------------- Adaptive Grav. Softening (including Lagrangian conservation terms!)
ADAPTIVE_GRAVSOFT_FORGAS       # allows variable softening length (=Hsml) for gas particles
####################################################################################################



####################################################################################################
# ----------------- Galaxy formation & Galactic Star formation
####################################################################################################
## ---------------------------------------------------------------------------------------------------
GALSF                           # master switch for galactic star formation model: enables SF, stellar ages, generations, etc. [cite Springel+Hernquist 2003, MNRAS, 339, 289]
## ----------------------------------------------------------------------------------------------------
# --- star formation law/particle spawning (additional options: otherwise all star particles will reflect IMF-averaged populations and form strictly based on a density criterion) ---- #
## ----------------------------------------------------------------------------------------------------
GALSF_SFR_MOLECULAR_CRITERION   # estimates molecular/self-shielded fraction in SF-ing gas, only SF from that is allowed. Cite Krumholz & Gnedin (ApJ 2011 729 36) and Hopkins et al., 2017a, arXiv:1702.06148
GALSF_SFR_VIRIAL_SF_CRITERION=0 # only allow star formation in virialized sub-regions (alpha<1) (0/no value='default'; 1=0+Jeans criterion; 2=1+'strict' (zero sf if not bound)). Cite Hopkins, Narayanan, & Murray 2013 (MNRAS, 432, 2647) and Hopkins et al., 2017a, arXiv:1702.06148
## ----------------------------------------------------------------------------------------------------
#------ PFH physical models for star formation and feedback: these are the FIRE simulation modules (Hopkins et al. 2014, Hopkins et al., 2017a, arXiv:1702.06148) ------ ##
#--------- Their use follows the FIRE authorship policy. Modules are NOT to be used without authors permission (including P. Hopkins, E. Quataert, D. Keres, and C.A. Faucher-Giguere),
#---------    even if you are already using the development GIZMO code. (PFH does not have sole authority to grant permission for the modules)
#--------- New projects using these modules must FIRST be PRE-APPROVED by the collaboration (after permission to use the modules has been explicitly granted),
#--------- and subsequently are required to follow the collaboration's paper approval and submission policies
##-----------------------------------------------------------------------------------------------------
FIRE_PHYSICS_DEFAULTS           # enable default set of FIRE physics packages (see details below); note use policy above
#----------- physical stellar feedback mechanisms (sub-modules of the FIRE_PHYSICS_DEFAULTS; these cannot be turned off and on individually without extreme care, they have complicated inter-dependencies) ---- #
##----------------------GALSF_FB_GASRETURN              # Paul Torrey's addition for stochastic gas return (modified for continuous return)
##----------------------GALSF_FB_HII_HEATING            # gas within HII regions around young stars is photo-heated to 10^4 K
##----------------------GALSF_FB_SNE_HEATING=1          # time-dependent explosions from SNe (I & II) in shockwave radii around stars (values: 0=force-gridded in xyz (WRONG-for testing only!); 1=tensor-symmetrized (momentum-conserving; USE ME); 2=no tensor re-normalization [non-conservative!]
##----------------------GALSF_FB_RPROCESS_ENRICHMENT=4  # tracks a set of 'dummy' species from neutron-star mergers (set to number: 4=extended model)
##----------------------GALSF_FB_RT_PHOTONMOMENTUM      # continuous acceleration from starlight (uses luminosity tree)
##----------------------GALSF_FB_LOCAL_UV_HEATING       # use local estimate of spectral information for photoionization and photoelectric heating
##----------------------GALSF_FB_RPWIND_LOCAL           # turn on local radiation pressure coupling to gas
############################################################################################################################



####################################################################################################
# --------------------------------------- Multi-Threading and Parallelization options
####################################################################################################
OPENMP=2                       # Masterswitch for explicit OpenMP implementation
MULTIPLEDOMAINS=16             # Multi-Domain option for the top-tree level (alters load-balancing)
####################################################################################################



####################################################################################################
# --------------------------------------- Input/Output options
####################################################################################################
OUTPUT_IN_DOUBLEPRECISION      # snapshot files will be written in double precision
OUTPUT_POTENTIAL               # forces code to compute+output potentials in snapshots
####################################################################################################



####################################################################################################
# -------------------------------------------- De-Bugging & special (usually test-problem only) behaviors
####################################################################################################
# --------------------
# ----- General De-Bugging and Special Behaviors
STOP_WHEN_BELOW_MINTIMESTEP    # forces code to quit when stepsize wants to go below MinSizeTimestep specified in the parameterfile
####################################################################################################
