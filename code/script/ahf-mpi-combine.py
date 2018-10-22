#!/usr/bin/env python
"""Combine AHF MPI multi-file outputs into single-file outputs."""
from pathlib import Path
import re
import subprocess as sp


# Detect prefixes
prefixes = set()
ahf_pattern = '^(.+)\.\d+\.z\d\.\d{3}\.AHF_[a-z]+$'
for path in Path('.').glob('*'):
    if path.is_file():
        match = re.match(ahf_pattern, str(path))
        if match:
            prefixes |= {match[1]}
print(f'Detected prefixes: {prefixes}')

for prefix in prefixes:
    # Centralize logs
    log_parts = f'{prefix}.*.log'
    log_dir = Path(f'{prefix}.log')
    log_dir.mkdir(exist_ok=True)
    print(f'Centralizing {log_parts}')
    sp.run(f'mv {log_parts} {log_dir}', shell=True)

    for ahf_type in ['halos', 'particles', 'profiles', 'substructure']:
        # Generate single-file outputs
        parts = f'{prefix}.*.AHF_{ahf_type}'
        out = f'{prefix}.AHF_{ahf_type}'
        print(f'Generating {out}')
        sp.run(f'cat {parts} > {out}', shell=True)

        # Remove original multi-file outputs
        print(f'Clearing {parts}')
        for file in Path('.').glob(parts):
            file.unlink()
