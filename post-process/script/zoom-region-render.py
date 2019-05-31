#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

import numpy as np
import yt


parser = ArgumentParser()
parser.add_argument('-s', '--snapshot')
parser.add_argument('-o', '--outdir', type=Path,
                    default='outdir')
parser.add_argument('-p', '--percentile', default=80)
parser.add_argument('-w', '--width', default=3)
parser.add_argument('-r', '--resolution', type=int, default=600)
args = parser.parse_args()
snapshot = args.snapshot
outdir = args.outdir
percentile = args.percentile
width = args.width  # Mpccm
resolution = args.resolution

# Load snapshot
ds = yt.frontends.gizmo.GizmoDataset(snapshot)
ad = ds.all_data()
pt = 'gas'

# Select high density region
dens = ad[pt, 'density'].to_value('code_density')
mask = dens > np.percentile(dens, percentile)

# Determine zoom region center
pos = ad[pt, 'position'][mask]
m = ad[pt, 'mass'][mask]
center = np.average(pos, weights=m, axis=0)

# Make projection plot
fields = ['H_nuclei_density', 'temperature', 'metallicity']
fields = [(pt, field) for field in fields]
proj = yt.ProjectionPlot(
    ds, 'z', fields, weight_field=(pt, 'H_nuclei_density'),
    center=center, width=ds.quan(width, 'Mpccm'), data_source=ad,
    buff_size=(resolution, resolution)
)
proj.set_unit('H_nuclei_density', 'cm**-3')
proj.set_cmap('H_nuclei_density', 'viridis')
proj.set_unit('temperature', 'K')
proj.set_cmap('temperature', 'hot')
proj.set_unit('metallicity', 'dimensionless')
proj.set_cmap('metallicity', 'cool')

# Save buffer
outdir.mkdir(parents=True, exist_ok=True)
proj.save(outdir / 'diag')
proj.frb.save_as_dataset(outdir / 'frb.h5')
