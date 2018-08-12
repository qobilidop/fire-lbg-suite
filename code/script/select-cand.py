#!/usr/bin/env python
"""Select halo candidates.

Candidates are host halos with Mvir/Msun in (1e11.8, 1e12.2).
"""
from argparse import ArgumentParser
from pathlib import Path
import subprocess as sp
import sys

import yt

from toolbox.ahf import read_ahf_csv

yt.enable_parallelism()
comm = yt.communication_system.communicators[-1]
rank = comm.rank
size = comm.size

if comm.rank == 0:
    parser = ArgumentParser()
    parser.add_argument(
        '-s', '--snap-file', type=Path,
        help='The snapshot file.'
    )
    parser.add_argument(
        '--ahf-dir', type=Path,
        help='Where the AHF results are saved.'
    )
    parser.add_argument(
        '-o', '--output', type=Path,
        help='Output halo candidates table.'
    )
    args = parser.parse_args()
else:
    args = None
args = comm.mpi_bcast(args, root=0)

# Load snapshot
ds = yt.load(str(args.snap_file))

# Load halo catalog
sp.run('cat *.AHF_halos > AHF_halos', shell=True, cwd=args.ahf_dir)
hc = read_ahf_csv(args.ahf_dir / 'AHF_halos')
## Convert mass unit from Msun/h to Msun
hc.Mvir /= ds.hubble_constant

# Select host halos within the mass range
hc = hc[hc.hostHalo == 0]
m_min, m_max = 10**11.8, 10**12.2
hc = hc[(m_min < hc.Mvir) & (hc.Mvir < m_max)]
hc.sort_values(by='Mvir', ascending=False, inplace=True)
hc.reset_index(drop=True, inplace=True)
if yt.is_root():
    print(f'{len(hc)} candidates found.')
    sys.stdout.flush()

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
    # Mvir, Menv are in Msun (not Msun/h!)
    # Rvir, Xc, Yc, Zc are in kpccm/h (aka code_length)
    hc = hc[['Menv', 'Mvir', 'Rvir', 'Xc', 'Yc', 'Zc']]
    # Save to disk
    hc.to_csv(args.output, index=False)
