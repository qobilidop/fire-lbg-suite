#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

import numpy as np
import yt


parser = ArgumentParser()
parser.add_argument('-s', '--snapshot')
parser.add_argument('-o', '--output', type=Path, default='frb.h5')
parser.add_argument('-p', '--percentile', default=80)
parser.add_argument('-l', '--scale', default=3)
parser.add_argument('--scale_unit', default='Mpccm')
parser.add_argument('-r', '--resolution', type=int, default=600)
args = parser.parse_args()

# Load snapshot
ds = yt.frontends.gizmo.GizmoDataset(args.snapshot)

# Prepare fields
pt = 'gas'
fields = ['H_nuclei_density', 'temperature', 'metallicity']
units = ['cm**-3', 'K', '1']
weight_field = 'H_nuclei_density'
weight_unit = 'cm**-3'
for field, unit in zip(fields, units):
    def _weighted_field(field, data):
        fn = field.name[1]
        fn = fn[len('weighted_'):]
        return data[pt, fn] * data[pt, weight_field]
    ds.add_field(
        (pt, f'weighted_{field}'),
        function=_weighted_field,
        units=f'{unit} * {weight_unit}',
        sampling_type='particle',
    )
fields = [(pt, f'weighted_{field}') for field in fields]
fields += [(pt, weight_field)]

# Determine center
ad = ds.all_data()
dens = ad[pt, 'density'].to_value('code_density')
mask = dens > np.percentile(dens, args.percentile)
pos = ad[pt, 'position'][mask]
m = ad[pt, 'mass'][mask]
center = np.average(pos, weights=m, axis=0)

# Select region
scale = ds.quan(args.scale, args.scale_unit)
box = ds.box(center - scale / 2, center + scale / 2)

# Make projection plot
buff_size = [args.resolution] * 2
proj = yt.ProjectionPlot(
    ds, 'z', fields, data_source=box,
    center=center, width=scale, buff_size=buff_size,
)
proj.set_unit('H_nuclei_density', 'cm**-2')
proj.set_unit((pt, 'weighted_H_nuclei_density'), 'cm**-3 * cm**-2')
proj.set_unit((pt, 'weighted_temperature'), 'K * cm**-2')
proj.set_unit((pt, 'weighted_metallicity'), 'cm**-2')

# Save buffer
args.output.parent.mkdir(parents=True, exist_ok=True)
proj.frb.save_as_dataset(args.output)
