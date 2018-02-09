# Sample z2h FIRE-2 Test Runs on [Bridges](https://www.psc.edu/bridges)

## Goal

Rerun one of the z2h halo (z2h350) with FIRE-2 physics and resolution (1 refinement level higher == 8 times higher in mass resolution), and larger zoom-in region (aiming at 0 contamination within halo at redshift 2).

## Progress

- [ ] Run ref12 with FIRE-2 physics.
- [ ] Run ref13_dm to determine larger zoom-in region iteratively.
- [ ] Run ref13 with FIRE-2 physics and larger zoom-in region.

## Code usage

### Prerequisites

- Access to Bridges (only works there)
- User-installed [Conda](https://conda.io) on Bridges (to create conda env)
- Access to GIZMO private version

### Install

```bash
make install
```

### Simulation Run

```bash
source init.sh
./script/render.py config/z2h350_ref12.yaml

cd run/z2h350_ref12
# make data
# make src
# make compile
make submit
```
