#!/usr/bin/env bash
#PBS -q condo
#PBS -l nodes=1:ppn=1
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -v ENV_ACTIVATE,SNAP
#PBS -d .
source job/common_pre.sh

./script/index.py -s "$SNAP"

source job/common_post.sh
