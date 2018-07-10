#!/usr/bin/env bash

set -e

cd "$PROJECT_DIR"
mkdir -p ~/data/"$PROJECT"
ln -s ~/data/"$PROJECT" data
mkdir data/raw
cd data/raw
ln -s ~/data/GalaxiesOnFIRE/boxes/L86
