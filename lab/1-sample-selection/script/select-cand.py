#!/usr/bin/env python
"""Select halo candidates.

Candidates are host halos with Mvir/Msun in (1e11.8, 1e12.2).
"""
import subprocess as sp

import yt

from src.env import repo_dir
from src.io import read_ahf_csv


yt.enable_parallelism()
data_dir = repo_dir / 'data'

# Load snapshot
snap_path = data_dir / 'box/L86/output/snapdir_005/snapshot_005.0.hdf5'
ds = yt.load(str(snap_path))

# Load halo catalog
ahf_dir = data_dir / 'box-halo/ahf'
sp.run('cat *.AHF_halos > AHF_halos', shell=True, cwd=ahf_dir)
hc = read_ahf_csv(ahf_dir / 'AHF_halos')
## Convert mass unit from Msun/h to Msun
hc.Mvir /= ds.hubble_constant

# Select host halos within the mass range
hc = hc[hc.hostHalo == 0]
m_min, m_max = 10 ** 11.8, 10 ** 12.2
hc = hc[(m_min < hc.Mvir) & (hc.Mvir < m_max)]
hc.sort_values(by='Mvir', ascending=False, inplace=True)
hc.reset_index(drop=True, inplace=True)
if yt.is_root():
    print(f'{len(hc)} candidates found.')

# Measure local environment density
storage = {}
for sto, (index, row) in yt.parallel_objects(list(hc.iterrows()),
                                             storage=storage,
                                             dynamic=True):
    center = ds.arr(row[['Xc', 'Yc', 'Zc']].values, 'kpccm/h')
    sp = ds.sphere(center, (1.8, 'Mpc'))
    m_env = float(sp['all', 'particle_mass'].sum().to('Msun'))
    sto.result_id = index
    sto.result = m_env
    print(index, m_env)

# Save candidates
if yt.is_root():
    hc['Menv'] = [m_env for _, m_env in sorted(storage.items())]
    # Select columns to save
    # Mvir, Menv in Msun (not Msun/h!)
    # Rvir, Xc, Yc, Zc in kpccm/h (aka code_length)
    hc = hc[['Mvir', 'Rvir', 'Xc', 'Yc', 'Zc', 'Menv']]
    # Save to disk
    hc.to_hdf(data_dir / 'box-halo/candidates.hdf5', key='data')
