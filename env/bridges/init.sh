#!/usr/bin/env bash
set -e

# Link data dir
cd "$PROJECT_DIR"
mkdir -p ~/data/"$PROJECT_NAME"
ln -fns ~/data/"$PROJECT_NAME" data

# Link box
mkdir -p data/box
ln -fs ~/data/GalaxiesOnFIRE/boxes/L86 data/box/
