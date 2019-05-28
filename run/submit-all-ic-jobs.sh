#!/usr/bin/env bash
set -e

for HALO in h00 h01 h02 h03 h10 h11 h12 h13; do
    cd z2m12_"$HALO"_ref13 && qsub job/ic.sh && cd -
done
