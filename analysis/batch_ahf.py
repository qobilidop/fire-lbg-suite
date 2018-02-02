#!/usr/bin/env python
from argparse import ArgumentParser
from subprocess import run
from pathlib import Path

from ahf import Job


parser = ArgumentParser()
parser.add_argument('--sim', type=Path)
args = parser.parse_args()

for snap in reversed(sorted(args.sim.glob('converted/*'))):
    job = Job(args.sim, snap, 'submit')
    job.main()
