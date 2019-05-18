#!/usr/bin/env python
"""Select halo candidate.

Candidate halos are a host halos with Mvir/Msun in (1e11.8, 1e12.2).
"""
import sys

import yt

from giztool import ahf

import config
import util


# Set up MPI
yt.enable_parallelism()
comm = yt.communication_system.communicators[-1]
rank = comm.rank
size = comm.size

# Load data
ds = util.load_snapshot()
hc = ahf.read_csv(config.HALO_CATALOG)

# Select host halos within the mass range
hc = hc[hc['hostHalo'] == 0]
hc['Mvir'] /= ds.hubble_constant  # Convert mass unit from Msun/h to Msun
m_min, m_max = 10**11.8, 10**12.2
hc = hc[(m_min < hc['Mvir']) & (hc['Mvir'] < m_max)]
hc.sort_values(by='Mvir', ascending=False, inplace=True)
hc.reset_index(drop=True, inplace=True)
if yt.is_root():
    print(f'{len(hc)} candidates found.')
    sys.stdout.flush()

# Measure local environment density
storage = {}
for sto, (index, row) in yt.parallel_objects(
        list(hc.iterrows()), storage=storage, dynamic=True
    ):
    center = ds.arr(row[['Xc', 'Yc', 'Zc']].values, 'kpccm/h')
    sp = ds.sphere(center, (1.8, 'Mpc'))
    m_env = float(sp['all', 'particle_mass'].sum().to('Msun'))
    sto.result_id = index
    sto.result = m_env
    print(index)

# Save candidates
if yt.is_root():
    hc['Menv'] = [m_env for _, m_env in sorted(storage.items())]
    # Select columns to save
    # Mvir, Menv are in Msun (not Msun/h!)
    # Rvir, Xc, Yc, Zc are in kpccm/h (aka code_length)
    hc = hc[['Mvir', 'Menv', 'Rvir', 'Xc', 'Yc', 'Zc']]
    # Save to disk
    hc.to_csv(config.CANDIDATE, index=False)
