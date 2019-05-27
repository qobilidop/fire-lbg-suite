#!/usr/bin/env python
"""Measure local environment density for candidate halos.

Reference:
https://yt-project.org/doc/analyzing/parallel_computation.html#parallelizing-over-multiple-objects

"""
from pathlib import Path
import struct

import pandas as pd
import yt


BASE_DIR = Path(__file__).parents[1].resolve()
SNAP = BASE_DIR / 'box/output/snapdir_005/snapshot_005.0.hdf5'
CAND = BASE_DIR / 'data/halo/candidate.csv'
R_ENV = 1.8  # Mpc


# Enable MPI
yt.enable_parallelism()

# Load data
ds = yt.load(str(SNAP))
ds.index
hc = pd.read_csv(CAND)
if yt.is_root():
    print(len(hc), 'halos to measure')

# Measure local environment density
storage = {}
for sto, (index, row) in yt.parallel_objects(
        list(hc.to_dict(orient='index').items()), storage=storage, dynamic=True
    ):
    cache = BASE_DIR / f'data/halo/menv-{index}'
    if cache.exists():
        m_env = struct.unpack('d', cache.read_bytes())[0]
        print(index, 'from cache')
    else:
        print(index, 'begin')
        center = ds.arr([row['Xc'], row['Yc'], row['Zc']], 'kpccm/h')
        sp = ds.sphere(center, (R_ENV, 'Mpc'))
        m_env = sp['all', 'particle_mass'].sum().to_value('Msun')
        cache.write_bytes(struct.pack('d', m_env))
        print(index, 'end')
    sto.result_id = index
    sto.result = m_env

# Update candidate table
if yt.is_root():
    hc['Menv'] = [m_env for _, m_env in sorted(storage.items())]
    hc = hc[['Mvir', 'Menv', 'Rvir', 'Xc', 'Yc', 'Zc', 'isolated']]
    hc.to_csv(CAND, index=False)
