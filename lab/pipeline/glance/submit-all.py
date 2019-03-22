#!/usr/bin/env python
from pathlib import Path
from subprocess import run

from toolbox.path import PROJECT_DIR
from toolbox.path import SIMS


CDIR = Path(__file__).parent.resolve()

TEMPLATE = """\
#!/bin/bash
#PBS -N {name}
#PBS -q condo
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -j oe
#PBS -o {name}.log
#PBS -V
#PBS -d .
set -e
date
cd {project_dir}
source ./activate
mkdir -p {work_dir}
cd {work_dir}
pwd

export OMP_NUM_THREADS=$PBS_NP

{cdir}/run.py {snap_file}

date
"""


def submit(snap):
    sim = snap.sim
    job_dir = CDIR / 'job'
    job_dir.mkdir(exist_ok=True)
    job_name = f'glance-{sim.name}-{snap.id:03d}'
    job_file = job_dir / f'{job_name}.sh'
    job_script = TEMPLATE.format(
        name=job_name,
        project_dir=PROJECT_DIR,
        work_dir=get_work_dir(snap),
        cdir=CDIR,
        snap_file=snap.file,
    )
    job_file.write_text(job_script)
    print(f'Submit {job_name}')
    run(['qsub', job_file], cwd=job_dir)


def finished(snap):
    work_dir = get_work_dir(snap)
    if len(list(work_dir.glob('*.png'))) == 5:
        return True
    return False


def get_work_dir(snap):
    return snap.sim.dir / 'glance' / f'snapshot_{snap.id:03d}'


if __name__ == '__main__':
    for sim in SIMS:
        for snap in sim.snaps:
            if snap.file.exists() and not finished(snap):
                submit(snap)
