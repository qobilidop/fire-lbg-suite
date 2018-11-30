#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import numpy as np
import pandas as pd
import yt

from giztool.sim.misc import trace_region_chull


parser = ArgumentParser()
parser.add_argument('--ic')
parser.add_argument('--snapshot')
parser.add_argument('--sample')
parser.add_argument('--radius', type=int)
parser.add_argument('--zoom_region_dir')
parser.add_argument('--plot')
args = parser.parse_args()

# Load data
ds_ic = yt.load(args.ic)
ic = ds_ic.all_data()
ds = yt.load(args.snapshot)
sample = pd.read_csv(args.sample)

# Initialize plot
p = yt.ParticleProjectionPlot(ds, 'z', 'particle_mass')
p.hide_axes()
p.hide_colorbar()
p.set_cmap('particle_mass', 'magma')
p.annotate_scale()
p.annotate_timestamp(redshift=True)

for row in sample.itertuples():
    # Select spherical zoom region
    label = row['label']
    center = center = ds.arr([row.Xc, row.Yc, row.Zc], 'kpccm/h')
    r_vir = ds.quan(row.Rvir, 'kpccm/h').to('code_length')
    radius = r_vir * args.radius
    sp = ds.sphere(center, radius)

    # Record zoom region
    vertices = trace_region_chull(sp, ic)
    path = Path(args.zoom_region_dir) / f'{label}_rad{args.radius}.txt'
    np.savetxt(path, vertices)

    # Plot halo
    p.annotate_text(center, label, inset_box_args={'alpha': 0})
    p.annotate_sphere(center, r_vir)
    p.annotate_sphere(center, radius,
        circle_args={'ls': 'dashed', 'color': 'white'})
    p.annotate_sphere(center, (1.8, 'Mpc'),
        circle_args={'ls': 'dotted', 'color': 'white'})

# Save plot
p.save(args.plot)
