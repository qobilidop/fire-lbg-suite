#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

import numpy as np
import yt


parser = ArgumentParser()
parser.add_argument('-s', '--snapshot')
parser.add_argument('-o', '--output', type=Path, default='center.txt')
parser.add_argument('-p', '--percentile', default=80)
args = parser.parse_args()

# Load snapshot
ds = yt.frontends.gizmo.GizmoDataset(args.snapshot)

# Determine center
ad = ds.all_data()
pt = 'gas'
dens = ad[pt, 'density'].to_value('code_density')
mask = dens > np.percentile(dens, args.percentile)
pos = ad[pt, 'position'][mask]
m = ad[pt, 'mass'][mask]
center = np.average(pos, weights=m, axis=0)

# Save output
center = center.to_value('code_length')
args.output.parent.mkdir(parents=True, exist_ok=True)
np.savetxt(args.output, center, fmt='%.3f')
