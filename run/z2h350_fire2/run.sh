#!/usr/bin/env bash

ln -fs ../common/* .
ln -fs ../varied/music_z2h.conf music.conf

mkdir -p job
mkdir -p output

RUN=z2h350_fire2 ./submit.sh
