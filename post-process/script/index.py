#!/usr/bin/env python
"""Index a snapshot to facilitate future yt operations."""
from argparse import ArgumentParser

import yt


parser = ArgumentParser()
parser.add_argument('-s', '--snapshot')
args = parser.parse_args()

ds = yt.frontends.gizmo.GizmoDataset(args.snapshot)
ds.index
