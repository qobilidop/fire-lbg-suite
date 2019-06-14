#!/usr/bin/env bash
#PBS -q condo
#PBS -l nodes=1:ppn=2
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -v ENV_ACTIVATE,SNAP,CFILE,OUT,FIELD,WFIELD,UNIT
#PBS -d .
source job/common_pre.sh

./script/projection.py -s "$SNAP" -c "$CFILE" -o "$OUT" -f "$FIELD" --weight_field "$WFIELD" --projection_unit "$UNIT"

source job/common_post.sh
