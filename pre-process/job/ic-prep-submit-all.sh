#!/usr/bin/env bash
set -e

for HALO in h00 h01 h02 h03 h10 h11 h12 h13; do
    export HALO
    qsub -N "ic-prep-$HALO" -o "job/ic-prep-$HALO.log" job/ic-prep.sh
done
