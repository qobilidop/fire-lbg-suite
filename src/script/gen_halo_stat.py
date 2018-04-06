#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

import yt


parser = ArgumentParser()
parser.add_argument('--snap', type=Path,
                    default='output/snapshot_190.hdf5')
parser.add_argument('--hc', type=Path,
                    default='ahf/snapshot_190.parameter')
parser.add_argument('--halo_id', type=int, default=0)
parser.add_argument('--out', type=Path, default='main_halo.csv')
args = parser.parse_args()

# Load datasets
ds = yt.load(str(args.snap))
ds_hc = yt.load(str(args.hc), hubble_constant=ds.hubble_constant)
ad = ds.all_data()
ad_hc = ds_hc.all_data()
center = ad_hc['particle_position'][args.halo_id]
ad.set_field_parameter('center', center)

# Extract stat
ID = args.halo_id
fMhires = float(ad_hc['fMhires'][ID].v)
Mvir = float(ad_hc['Mvir'][ID].to('Msun').v)
Rvir = float(ad_hc['Rvir'][ID].to('kpc').v)
Rcon = float(ad['PartType2', 'particle_radius'].min().to('kpc').v)
Xc, Yc, Zc = center.to('unitary').v

# Write to output file
with args.out.open('w') as f:
    f.write('ID, fMhires, Mvir, Rvir, Rcon, Rcon/Rvir, Xc, Yc, Zc\n')
    f.write(f'{ID}, {fMhires:.3f}, {Mvir:.2e}, ')
    f.write(f'{Rvir:.0f}, {Rcon:.0f}, {Rcon/Rvir:.2f}, ')
    f.write(f'{Xc:.3f}, {Yc:.3f}, {Zc:.3f}\n')
