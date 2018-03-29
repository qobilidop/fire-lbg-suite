# Sample z2h FIRE-2 Test Runs on [Bridges](https://www.psc.edu/bridges)

## Goal

Rerun some of the z2h halos with FIRE-2 physics and resolution (1 refinement level higher == 8 times higher in mass resolution), and larger zoom-in region (aiming at 0 contamination within main halo at redshift 2).

## Protocols

### Set up the environment

First, we need to install all the softwares needed to compile MUSIC and GIZMO, run the simulation, and analyze the outputs. This is done in the following commands
```bash
source init-bridges.sh
make install
```

Later on, before running each simulation, make sure the environments are properly set up by
```bash
source init-bridges.sh
```

### Run a simulation

Initialize a simulation directory from a config file
```bash
init-sim.py sim.yaml
```

Submit the jobs to run the simulation
```bash
cd sim
make submit
```
