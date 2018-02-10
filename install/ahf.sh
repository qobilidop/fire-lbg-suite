#!/usr/bin/env bash

cd $(dirname $0)
cd .. && source init.sh && cd install
AHF_DM_PATCH="$PWD/ahf_dm_Makefile.config.patch"
AHF_PATCH="$PWD/ahf_Makefile.config.patch"

# Download source code
mkdir -p $REPO_PREFIX/src
cd $REPO_PREFIX/src
curl http://popia.ft.uam.es/AHF/files/ahf-v1.0-094.tgz | tar -vxz
cd ahf-v1.0-094

# Install
mkdir -p $REPO_PREFIX/bin
# AHF_DM
patch < $AHF_DM_PATCH
make AHF
mv bin/AHF-v1.0-094 $REPO_PREFIX/bin/AHF_DM
patch -R < $AHF_DM_PATCH
make clean
# AHF
patch < $AHF_PATCH
make AHF
mv bin/AHF-v1.0-094 $REPO_PREFIX/bin/AHF
patch -R < $AHF_PATCH
make clean
