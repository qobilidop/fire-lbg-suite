#!/usr/bin/env python
import os
from pathlib import Path
import subprocess as sp


for i in range(2):
    for j in range(4):
        label = f'h{i}{j}'
        os.environ['HALO_LABEL'] = label
        cmd = ['qsub', 'box.sh',
               '-N', f'box-{label}',
               '-o', f'box-{label}.log']
        sp.run(cmd, cwd=Path(__file__).parent)
