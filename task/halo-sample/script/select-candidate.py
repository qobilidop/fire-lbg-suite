#!/usr/bin/env python
"""Select halo candidate.

Candidate halo is a host halo with Mvir/Msun in (1e11.8, 1e12.2).
"""
from argparse import ArgumentParser

import yt

from giztool import ahf


# Set up MPI
yt.enable_parallelism()
comm = yt.communication_system.communicators[-1]
rank = comm.rank
size = comm.size

# Parse arguments
if comm.rank == 0:
    parser = ArgumentParser()
    parser.add_argument('--snapshot')
    parser.add_argument('--halo_catalog')
    parser.add_argument('--candidate')
    args = parser.parse_args()
else:
    args = None
args = comm.mpi_bcast(args, root=0)

# Load snapshot
ds = yt.load(str(args.snapshot))

# Load halo catalog
hc = ahf.read_csv(args.halo_catalog)
## Convert mass unit from Msun/h to Msun
hc['Mvir'] /= ds.hubble_constant

# Select candidate within the mass range
candidate = hc[hc['hostHalo'] == 0]
candidate['Mvir'] /= ds.hubble_constant
m_min, m_max = 10**11.8, 10**12.2
candidate = candidate[(candidate['Mvir'] > m_min) &
                      (candidate['Mvir'] < m_max)]
candidate.sort_values(by='Mvir', ascending=False, inplace=True)
candidate.reset_index(drop=True, inplace=True)
if yt.is_root():
    print(f'{len(candidate)} candidates found.')
    sys.stdout.flush()

# Measure local environment density
storage = {}
for sto, (index, row) in yt.parallel_objects(
        list(candidate.iterrows()), storage=storage, dynamic=True
    ):
    center = ds.arr(row[['Xc', 'Yc', 'Zc']].values, 'kpccm/h')
    sp = ds.sphere(center, (1.8, 'Mpc'))
    m_env = float(sp['all', 'particle_mass'].sum().to('Msun'))
    sto.result_id = index
    sto.result = m_env
    print(index)

# Save candidate
if yt.is_root():
    candidate['Menv'] = [m_env for _, m_env in sorted(storage.items())]
    # Select columns to save
    # Mvir, Menv are in Msun (not Msun/h!)
    # Rvir, Xc, Yc, Zc are in kpccm/h (aka code_length)
    candidate = candidate[['Mvir', 'Menv', 'Rvir', 'Xc', 'Yc', 'Zc']]
    # Save to disk
    candidate.to_csv(args.candidate, index=False)
