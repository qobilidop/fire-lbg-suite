#!/usr/bin/env python
from pathlib import Path


with Path('results.csv').open('w') as f:
    f.write('run, cpu, wall_time_h, cpu_time_h\n')
    for output in sorted(Path('.').glob('*/output')):
        run = output.parent.name
        nodes = int(run.split('_')[0][1:])
        cpus = nodes * 28
        ctimes = [p.stat().st_ctime for p in output.glob('*')
                  if not p.is_symlink()]
        wall_time_s = max(ctimes) - min(ctimes)
        wall_time_h = wall_time_s / 3600
        cpu_time_h = cpus * wall_time_h
        f.write(f'{run}, {cpus}, {wall_time_h:.1f}, {cpu_time_h:.1f}\n')
