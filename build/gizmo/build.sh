#!/usr/bin/env bash

cp Config.sh $REPO_GIZMO_SRC/
cp Makefile $REPO_GIZMO_SRC/
cp Makefile.systype $REPO_GIZMO_SRC/
cd $REPO_GIZMO_SRC

make

mkdir -p $REPO_PREFIX/bin
cp GIZMO $REPO_PREFIX/bin/
