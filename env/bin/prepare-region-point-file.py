#!/usr/bin/env python
"""Prepare region point file to use with MUSIC."""
from argparse import ArgumentParser

import numpy as np
import pandas as pd
from scipy.spatial import ConvexHull
import yt

from toolbox.num import periodic_center_of_mass


def main():
    parser = ArgumentParser()
    parser.add_argument(
        '--halo_sample',
        help='Halo sample file path.'
    )
    parser.add_argument(
        '--halo_label',
        help='The label used to identify a halo within the halo sample.'
    )
    parser.add_argument(
        '--halo_snap',
        help='Halo snapshot file path.'
    )
    parser.add_argument(
        '--ic_snap',
        help='Initial condition snapshot file path.'
    )
    parser.add_argument(
        '--zoom_radius', type=float,
        help='Zoom region radius in unit of virial radius.'
    )
    parser.add_argument(
        '--output',
        help='The output region point file path.'
    )
    args = parser.parse_args()

    # Retrieve halo info
    sample = pd.read_csv(args.halo_sample, index_col='label')
    halo_info = sample.loc[args.halo_label]

    # Determine particle IDs to track
    ds = load_snap(args.halo_snap)
    center = ds.arr(halo_info[['Xc', 'Yc', 'Zc']].values, 'kpccm/h')
    r_vir = ds.quan(halo_info['Rvir'], 'kpccm/h')
    sp = ds.sphere(center, r_vir * args.zoom_radius)
    pid = sp['particle_index']

    # Track particle positions in IC
    ds = load_snap(args.ic_snap)
    ad = ds.all_data()
    mask = np.isin(ad['particle_index'], pid)
    pos = ad['particle_position'][mask].to('unitary').v

    # Transform to center-of-mass coordinates to ensure no boundary crossing
    box_size = np.array([1., 1., 1.])
    mass = ad['particle_mass'][mask].to('Msun').v
    center = periodic_center_of_mass(pos, box_size, mass=mass)
    pos -= center

    # Compress positions by convex hull vertices
    chull = ConvexHull(pos)
    vertices = chull.points[chull.vertices]

    # Transform back to original coordinates
    vertices += center
    vertices = np.remainder(vertices, 1.)

    # Save output
    np.savetxt(args.output, vertices)


def load_snap(path, **yt_load_kwargs):
    # Add some padding to bbox to avoid domain overflow issue
    from toolbox.const import BOX_SIZE
    eps = 1e-10
    bbox = [[-eps, BOX_SIZE + eps]] * 3
    return yt.load(path, bounding_box=bbox, **yt_load_kwargs)


if __name__ == '__main__':
    main()
