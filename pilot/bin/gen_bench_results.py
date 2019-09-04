#!/usr/bin/env python
from pathlib import Path
import re


with Path('results.csv').open('w') as f:
    f.write('run,nodes,threads,cpus,wall_time_h,cpu_time_h\n')
    for output in sorted(Path('.').glob('*/output')):
        print(output)
        run = output.parent.name
        nodes, threads = re.match(f'n([0-9]+)_t([0-9]+)', run).group(1, 2)
        nodes = int(nodes)
        threads = int(threads)
        cpus = nodes * 28
        ctimes = [p.stat().st_ctime for p in output.glob('*')
                  if not p.is_symlink()]
        wall_time_s = max(ctimes) - min(ctimes)
        wall_time_h = wall_time_s / 3600
        cpu_time_h = cpus * wall_time_h
        f.write(f'{run},{nodes},{threads},{cpus},{wall_time_h:.2f},{cpu_time_h:.2f}\n')
