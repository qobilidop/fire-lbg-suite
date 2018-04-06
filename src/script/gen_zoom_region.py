#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path
from subprocess import run

import numpy as np
from scipy.spatial import ConvexHull
import yt


parser = ArgumentParser()
parser.add_argument('--rad', type=float, default=4)
parser.add_argument('--snap', type=Path,
                    default='output/snapshot_190.hdf5')
parser.add_argument('--hc', type=Path,
                    default='ahf/snapshot_190.parameter')
parser.add_argument('--halo_id', type=int, default=0)
parser.add_argument('--ic', type=Path, default='ic/ics.dat')
parser.add_argument('--out', type=Path, default='zoom_region.txt')
args = parser.parse_args()

# Load datasets
ds = yt.load(str(args.snap))
ds_hc = yt.load(str(args.hc), hubble_constant=0.703)
ds_ic = yt.load(str(args.ic))

# Select zoom region
ad_hc = ds_hc.all_data()
center = ad_hc['particle_position'][args.halo_id]
radius = ad_hc['virial_radius'][args.halo_id]
zr = ds.sphere(center, radius * args.rad)

# Trace particles back to IC
zr_pids = zr['particle_index']
ad_ic = ds_ic.all_data()
ic_pids = ad_ic['particle_index']
mask = np.in1d(ic_pids, zr_pids, assume_unique=True)
zr_points = ad_ic['particle_position'][mask].to('unitary').v

# Compress number of points by convex hull
zr_hull = ConvexHull(zr_points)
zr_hull_vertices = zr_hull.points[zr_hull.vertices]
np.savetxt(args.out, zr_hull_vertices, fmt='%.8f')
