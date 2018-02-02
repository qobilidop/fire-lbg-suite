#!/usr/bin/env python
from argparse import ArgumentParser
from subprocess import run
from pathlib import Path

from halo_proj import Job


parser = ArgumentParser()
parser.add_argument('--sim', type=Path)
parser.add_argument('--halo', type=Path)
parser.add_argument('--snap_pattern', type=str, default='output/*')
args = parser.parse_args()

for i, snap in enumerate(reversed(sorted(args.sim.glob(args.snap_pattern)))):
    if i <= 100:
        job = Job(args.sim, args.halo, snap, 'submit')
        job.main()
