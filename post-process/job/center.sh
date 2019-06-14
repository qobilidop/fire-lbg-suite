#!/usr/bin/env bash
#PBS -q condo
#PBS -l nodes=1:ppn=1
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -v ENV_ACTIVATE,SNAP,OUT
#PBS -d .
source job/common_pre.sh

./script/zoom-region-center.py -s "$SNAP" -o "$OUT"

source job/common_post.sh
