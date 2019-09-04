#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path


template = """
import: .common.yaml
gizmo:
    MaxMemSize: {MaxMemSize:d}
    job:
        nodes: {nodes:d}
        mpi_tasks: {mpi_tasks:d}
        omp_threads: {omp_threads:d}
"""
# Remove the empty line at the beginning
template = template[1:]


parser = ArgumentParser()
parser.add_argument('--n_min', type=int)
parser.add_argument('--n_max', type=int)
parser.add_argument('--t_min', type=int)
parser.add_argument('--t_max', type=int)
args = parser.parse_args()


for log_n in range(args.n_min, args.n_max + 1):
    for log_t in range(args.t_min, args.t_max + 1):
        n = 2 ** log_n
        t = 2 ** log_t
        path = Path(f'n{n:03d}_t{t:1d}.yaml')
        text = template.format(
            MaxMemSize = t * 4000,
            nodes = n,
            mpi_tasks = 28 // t,
            omp_threads = t
        )
        print(f'Writing {path}')
        path.write_text(text)
