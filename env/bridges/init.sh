#!/usr/bin/env bash
set -e

echo "Install local Python packages"
which pip
env MPICC="$LOCAL_MPICC" pip install mpi4py

echo "Link data dir"
cd "$PROJECT_DIR"
data_dir="$HOME/data/$PROJECT_NAME"
mkdir -p "$data_dir"
mv data/* "$data_dir/"
rm -r data
ln -s "$data_dir" data

echo "Link raw data"
mkdir -p data/box
ln -fs ~/data/GalaxiesOnFIRE/boxes/L86 data/box/
