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
    out_dir = run_dir / f'analysis/snap_{snap_id3}'

    os.environ['SNAP'] = str(snap_file)
    os.environ['CFILE'] = str(out_dir / 'zoom_region_center.txt')

    out_file = out_dir / 'frb-H_nuclei_density.h5'
    os.environ['OUT'] = str(out_file)
    os.environ['FIELD'] = 'H_nuclei_density'
    os.environ['UNIT'] = 'cm**-2'
    if snap_file.exists() and not out_file.exists():
        job_name = f'proj-n-{halo_name}-{snap_id3}'
        print('Submiting', job_name)
        run(['qsub', '-N', job_name, '-o', f'job/{job_name}.log', 'job/proj.sh'])

    out_file = out_dir / 'frb-H_nuclei_density-H_nuclei_density.h5'
    os.environ['OUT'] = str(out_file)
    os.environ['FIELD'] = 'H_nuclei_density'
    os.environ['WFIELD'] = 'H_nuclei_density'
    os.environ['UNIT'] = 'cm**-5'
    if snap_file.exists() and not out_file.exists():
        job_name = f'projw-n-{halo_name}-{snap_id3}'
        print('Submiting', job_name)
        run(['qsub', '-N', job_name, '-o', f'job/{job_name}.log', 'job/projw.sh'])

    out_file = out_dir / 'frb-temperature-H_nuclei_density.h5'
    os.environ['OUT'] = str(out_file)
    os.environ['FIELD'] = 'temperature'
    os.environ['WFIELD'] = 'H_nuclei_density'
    os.environ['UNIT'] = 'K * cm**-2'
    if snap_file.exists() and not out_file.exists():
        job_name = f'projw-T-{halo_name}-{snap_id3}'
        print('Submiting', job_name)
        run(['qsub', '-N', job_name, '-o', f'job/{job_name}.log', 'job/projw.sh'])

    out_file = out_dir / 'frb-metallicity-H_nuclei_density.h5'
    os.environ['OUT'] = str(out_file)
    os.environ['FIELD'] = 'metallicity'
    os.environ['WFIELD'] = 'H_nuclei_density'
    os.environ['UNIT'] = 'cm**-2'
    if snap_file.exists() and not out_file.exists():
        job_name = f'projw-Z-{halo_name}-{snap_id3}'
        print('Submiting', job_name)
        run(['qsub', '-N', job_name, '-o', f'job/{job_name}.log', 'job/projw.sh'])
