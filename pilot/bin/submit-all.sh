#!/usr/bin/env bash

for sim in */; do
    cd $sim
    make submit
    cd ..
done
