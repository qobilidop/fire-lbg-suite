#!/usr/bin/env python
"""Track zoom region and prepare MUSIC point file."""
from argparse import ArgumentParser
from pathlib import Path

import numpy as np
import pandas as pd
from scipy.spatial import ConvexHull
import yt


BASE_DIR = Path(__file__).parents[1].resolve()
SAMPLE = BASE_DIR / 'data/halo/sample.csv'
SNAP_IC = BASE_DIR / 'box/initial_condition/ic_L86_ref10_dm.ics'
SNAP_HALO = BASE_DIR / 'box/output/snapdir_005/snapshot_005.0.hdf5'
ZOOM_REGION_DIR = BASE_DIR / 'data/zoom-region'
BOX_SIZE = 58480  # kpc/h
R_ZOOM = 4


def load_snap(path):
    # Relax the bounding box a little bit to solve an error
    eps = 1e-10
    bbox = [[-eps, BOX_SIZE + eps]] * 3
    return yt.load(str(path), bounding_box=bbox)


parser = ArgumentParser()
parser.add_argument('halo_name')
args = parser.parse_args()
halo_name = args.halo_name

# Retrieve halo info
sample = pd.read_csv(SAMPLE, index_col='name')
halo = sample.to_dict(orient='index')[halo_name]

# Determine particle IDs to track
print('Loading halo snapshot')
ds = load_snap(SNAP_HALO)
center = ds.arr([halo['Xc'], halo['Yc'], halo['Zc']], 'kpccm/h')
r_vir = ds.quan(halo['Rvir'], 'kpccm/h')
sp = ds.sphere(center, r_vir * R_ZOOM)
pid = sp['particle_index']

# Track particle positions in IC
print('Loading IC snapshot')
ds = load_snap(SNAP_IC)
ad = ds.all_data()
mask = np.isin(ad['particle_index'], pid)
pos = ad['particle_position'][mask].to_value('unitary')

# Center on one particle to ensure no boundary crossing
center = pos[0]
pos -= center

# Reduce the number of particles using convex hull vertices
print('Constructing convex hall')
chull = ConvexHull(pos)
vertices = chull.points[chull.vertices]

# Transform back to the original coordinates
vertices += center
vertices = np.remainder(vertices, 1.)

# Save zoom region point file
print('Saving zoom region file')
ZOOM_REGION_DIR.mkdir(parents=True, exist_ok=True)
zoom_region_file = ZOOM_REGION_DIR / f'{halo_name}-box-rad{R_ZOOM}.txt'
np.savetxt(zoom_region_file, vertices)
