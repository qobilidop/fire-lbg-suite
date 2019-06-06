#!/usr/bin/env python
from itertools import product
import os
from subprocess import run
from pathlib import Path


BASE_DIR = Path(__file__).parents[1].resolve()


for i, j, snap_id in product(range(2), range(4), range(173)):
    halo_name = f'h{i}{j}'
    snap_id3 = f'{snap_id:03d}'
    run_dir = BASE_DIR / f'run/z2m12_{halo_name}_ref13'
    snap_file = run_dir / f'output/snapdir_{snap_id3}/snapshot_{snap_id3}.0.hdf5'
    out_file = run_dir / f'analysis/zoom_region/snap_{snap_id3}_frb.h5'
    if snap_file.exists() and not out_file.exists():
        os.environ['SNAP'] = str(snap_file)
        os.environ['OUTPUT'] = str(out_file)
        job_name = f'zreg-{halo_name}-{snap_id3}'
        print('Submiting', job_name)
        run(['qsub', '-N', job_name, '-o', f'job/{job_name}.log', 'job/zreg.sh'])
