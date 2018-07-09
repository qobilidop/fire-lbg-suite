#!/usr/bin/env bash

cd "$PROJECT_DIR/conda"
source enable-conda

for recipe in recipe/* ; do
	conda build "$recipe" --output-folder channel -c conda-forge
done
