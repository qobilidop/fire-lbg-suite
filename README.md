# Sample z2h FIRE-2 Test Runs on [Bridges](https://www.psc.edu/bridges)

## Prerequisite

- Access to Bridges (only works there)
- User-installed [Conda](https://conda.io) on Bridges (to create conda env)
- Access to GIZMO private version

## Install

```bash
make install
```

## Simulation Run

```bash
source init.sh
./script/render.py config/z2h350_ref12.yaml

cd run/z2h350_ref12
# make data
# make src
# make compile
make submit
```
