#!/usr/bin/env python
from functools import partial
import subprocess as sp
import sys


def run(cmd):
    print(' '.join(cmd))
    cp = sp.run(cmd, check=True, stdout=sp.PIPE, encoding=sys.stdout.encoding)
    print(cp.stdout)
    return cp.stdout


if __name__ == '__main__':
    run(['check-local-env', 'bridges'])

    out = run(['sbatch', 'bridges-job/ahf-setup.sh'])
    id_ahf_setup = out.split()[-1]
    out = run(['sbatch', f'--dependency=afterok:{id_ahf_setup}',
               'bridges-job/ahf-run.sh'])
    id_ahf_run = out.split()[-1]
