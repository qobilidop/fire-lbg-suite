#!/usr/bin/env bash

cp Makefile $REPO_MUSIC_SRC/
cd $REPO_MUSIC_SRC

make

mkdir -p $REPO_PREFIX/bin
cp MUSIC $REPO_PREFIX/bin/
