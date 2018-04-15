#!/usr/bin/env bash

for sim in */; do
    cd $sim
    make compile
    cd ..
done
