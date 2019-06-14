#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

import numpy as np
import yt


parser = ArgumentParser()
parser.add_argument('-s', '--snapshot')
parser.add_argument('-c', '--center_file')
parser.add_argument('-o', '--output', type=Path, default='frb.h5')
parser.add_argument('-f', '--field', default='H_nuclei_density')
parser.add_argument('--weight_field', default=None)
parser.add_argument('--projection_unit', default='cm**-2')
parser.add_argument('--axis', default='z')
parser.add_argument('--particle_type', default='gas')
parser.add_argument('-r', '--resolution', type=int, default=600)
parser.add_argument('-w', '--width', default=3)
parser.add_argument('-d', '--depth', default=3)
parser.add_argument('--length_unit', default='Mpccm')
args = parser.parse_args()

# Load snapshot
ds = yt.frontends.gizmo.GizmoDataset(args.snapshot)

# Load center
center = np.loadtxt(args.center_file)
center = ds.arr(center, 'code_length')

# Prepare fields
pt = args.particle_type
field_to_project = args.field
if args.weight_field is not None:
    field_to_project = f'weighted_{field_to_project}'
    def _weighted_field(field, data):
        fn = field.name[1]
        fn = fn[len('weighted_'):]
        return data[pt, fn] * data[pt, args.weight_field]
    ds.add_field(
        (pt, field_to_project),
        function=_weighted_field,
        units=f'{args.projection_unit} / cm',
        sampling_type='particle',
    )

# Select projection region
l_half = np.array([args.width / 2] * 3)
l_half['xyz'.index(args.axis)] = args.depth / 2
l_half = ds.arr(l_half, args.length_unit)
box = ds.box(center - l_half, center + l_half)

# Make projection plot
buff_size = [args.resolution] * 2
proj = yt.ProjectionPlot(
    ds, args.axis, (pt, field_to_project),
    data_source=box,
    center=center,
    width=(args.width, args.length_unit),
    buff_size=buff_size,
)
proj.set_unit((pt, field_to_project), args.projection_unit)

# Save buffer
args.output.parent.mkdir(parents=True, exist_ok=True)
proj.frb.save_as_dataset(args.output)
