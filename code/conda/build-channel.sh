#!/usr/bin/env bash

# Set working directory
cd $(dirname $0)

# Make sure channel directory exists
mkdir -p channel

# Build all recipes
for recipe in recipe/*
do
    echo "Building $recipe"
    # https://conda.io/docs/commands/build/conda-build.html
    conda build $recipe --output-folder channel -c conda-forge -c ./channel
    echo
done
