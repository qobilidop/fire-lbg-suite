#!/usr/bin/env python
"""Prepare region point file to use with MUSIC."""
from argparse import ArgumentParser

import pandas as pd
from scipy.spatial import ConvexHull

from .lib.num import periodic_center_of_mass


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
    ds = yt.load(args.halo_snap)
    center = ds.quan(halo_info[['Xc', 'Yc', 'Zc']], 'code_length')
    r_vir = ds.quan(halo_info['Rvir'], 'code_length')
    sp = ds.sphere(center, r_vir * args.zoom_radius)
    pid = sp['particle_index']

    # Track particle positions in IC
    ds = yt.load(ic_file)
    ad = ds.all_data()
    mask = np.isin(ad['particle_index'], pid)
    pos = ad['particle_position'][mask].to('unitary').v

    # Transform to center-of-mass coordinates to ensure no boundary crossing
    box_size = np.array([1., 1., 1.])
    mass = ad['particle_mass'].to('Msun').v
    center = periodic_center_of_mass(points, box_size, mass=mass)
    pos -= center

    # Compress positions by convex hull vertices
    chull = ConvexHull(pos)
    vertices = chull.points[chull.vertices]

    # Transform back to original coordinates
    vertices += center
    vertices = np.remainder(vertices, 1.)

    # Save output
    np.savetxt(region_point_file, vertices)


if __name__ == '__main__':
    main()
