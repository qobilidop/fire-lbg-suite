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
set -e
date
cd {project_dir}
source ./activate
mkdir -p {work_dir}
cd {work_dir}
pwd

export OMP_NUM_THREADS=$PBS_NP

AHF_INPUT="$(ahfio prep {snap_file} -c {cdir}/config.json)"
AHF-hyd "$AHF_INPUT"

date
"""


def submit(snap):
    sim = snap.sim
    job_dir = CDIR / 'job'
    job_dir.mkdir(exist_ok=True)
    job_name = f'ahf-{sim.name}-{snap.id:03d}'
    job_file = job_dir / f'{job_name}.sh'
    job_script = TEMPLATE.format(
        name=job_name,
        project_dir=PROJECT_DIR,
        work_dir=sim.dir / 'ahf',
        snap_file=snap.file,
        cdir=CDIR,
    )
    job_file.write_text(job_script)
    print(f'Submit {job_name}')
    run(['qsub', job_file], cwd=job_dir)


def finished(snap):
    work_dir = snap.sim.dir / 'ahf'
    if list(work_dir.glob('snapshot_{snap.id:03d}.*.AHF_halos')):
        return True
    return False


if __name__ == '__main__':
    for sim in SIMS:
        for snap in sim.snaps:
            if snap.file.exists() and not finished(snap):
                submit(snap)
