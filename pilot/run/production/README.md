# Notes

## General procedure

1. Run z2hxxx_ref13_dm to get a high resolution zoom region.
2. Redefine IC from z2hxxx_ref13_dm using a sphere of 4 Rvir.
    1. After the run is finished, in the simulation directory, run `ahf.py` for halo_finding.
    2. Change directory to `data/zoom_region` and run `make` to generate zoom region files. Here we generate zoom regions corresponding to radius from 2 to 6 Rvir.
3. Run z2hxxx_ref13_rad4_dm from the new IC to check contamination.
    1. After the run is finished, change directory to `data/contamination` and run `make` to generate contamination files.
4. If the contamination is not zero, iterate 2 and 3. Otherwise, run the hydro simulations from the refined IC.
