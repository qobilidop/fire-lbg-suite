#!/usr/bin/env bash

cd $(dirname $0)
cd .. && source init.sh && cd install
AHF_PATCH="$PWD/ahf_Makefile.config.patch"

# Download source code
mkdir -p $REPO_PREFIX/src
cd $REPO_PREFIX/src
curl http://popia.ft.uam.es/AHF/files/ahf-v1.0-094.tgz | tar -vxz
cd ahf-v1.0-094
patch < $AHF_PATCH

# Install
mkdir -p $REPO_PREFIX/bin
make AHF
mv bin/AHF-v1.0-094 $REPO_PREFIX/bin/AHF
