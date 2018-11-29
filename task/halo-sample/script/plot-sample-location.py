#!/usr/bin/env python
"""Plot sample location."""
from argparse import ArgumentParser

import matplotlib
matplotlib.use('Agg')
import pandas as pd
import yt


# Parse arguments
parser = ArgumentParser()
parser.add_argument('--snapshot')
parser.add_argument('--sample')
parser.add_argument('--plot')
args = parser.parse_args()

# Load data
ds = yt.load(args.snapshot, n_ref=1024)
sample = pd.read_csv(args.sample)

# Make plot
p = yt.ParticleProjectionPlot(ds, 'z', 'particle_mass')
p.hide_axes()
p.hide_colorbar()
p.set_cmap('particle_mass', 'magma')
p.annotate_scale()
p.annotate_timestamp(redshift=True)
for row in sample.itertuples():
    center = ds.arr([row.Xc, row.Yc, row.Zc], 'kpccm/h')
    r_vir = ds.quan(row.Rvir, 'kpccm/h').to('code_length')
    # p.annotate_text(center, row.label, inset_box_args={'alpha': 0})
    p.annotate_sphere(center, r_vir)
    p.annotate_sphere(center, r_vir*3,
        circle_args={'ls': 'dashed', 'color': 'white'})
    p.annotate_sphere(center, (1.8, 'Mpc'),
        circle_args={'ls': 'dotted', 'color': 'white'})
p.save(args.plot)
